import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import datetime
import json
from google.cloud.firestore import FieldFilter
import random

cred = credentials.Certificate("./serviceAccountKey.json")

app = firebase_admin.initialize_app(cred)

db = firestore.client()

CURUSER = 'joshcordero2134@gmail.com'


def add_users(file):
    with open(file) as f:
        data = json.load(f)
        for user in data:
            # conver the dateOfBirth string 2003-02-28T08:00:00.399Z to a datetime object
            user['dateOfBirth'] = datetime.datetime.strptime(user['dateOfBirth'], '%Y-%m-%dT%H:%M:%S.%fZ')
            db.collection('users').document(user['email']).set(user)


def add_exercises(file):
    with open(file) as f:
        data = json.load(f)
        for exercise in data:
            db.collection('exercises').add(exercise)


# setup only needs to be run once
# add_users("./sampleData/users.json")
# add_exercises("./sampleData/exercises.json")
            
def calculate_score(score_list: list[int], date_list: list[datetime.datetime]) -> float:

    if len(score_list) == 0:
        return 0

    # approach 1 exponential moving average

    multiplier = 2 / (len(score_list) + 1)
    score = score_list[-1]
    for i in reversed(range(len(score_list))):
        score = score * multiplier + score_list[i] * (1 - multiplier)

    # if it has been a while since the user last did this workout, give
    # a random probability of reseting the score
    days_since = (datetime.datetime.now(tz=datetime.timezone.utc) - date_list[0]).days
    if days_since > 14:
        if random.random() > 0.5:
            score = 0

    return score

def calculate_sets_reps_weight(
        sets_list: list[int], 
        reps_list: list[int], 
        weight_list: list[int], 
        date_list: list[datetime.datetime], 
        base_weight: int,
        min_workouts: int = 3,
        base_sets: int = 3,
        base_reps: int = 10,
        ) -> tuple[int, int, int]:
    # calcuate the sets, reps, and weight that should be recommended to the user based on history
    # all list should be sorted with most recent workout at the front

    assert date_list == sorted(date_list, reverse=True)

    # if there are no workouts, return the default
    if len(date_list) == 0:
        return base_sets, base_reps, base_weight
    
    # if there is less than the minimum number of workouts, return the most recent workout
    if len(date_list) < min_workouts:
        return sets_list[0], reps_list[0], weight_list[0]
    
    # there are enough workouts to make recommendation

    days_since_last_workout = (datetime.datetime.now(tz=datetime.timezone.utc) - date_list[0]).days

    # if the user has not worked out in a while, return the a workout that is easier
    if days_since_last_workout > 28:
        return base_sets, base_reps, weight_list[0] * 0.9
    
    # if the user had a change within the last 2 workouts return the most recent workout
    if sets_list[0] != sets_list[1] or reps_list[0] != reps_list[1] or weight_list[0] != weight_list[1]:
        return sets_list[0], reps_list[0], weight_list[0]
    

    # now time for the actual recommendation
    '''
    We will use a progressive overload approach to recommend the next workout
    '''

    # first we will increase the reps
    if reps_list[0] < 14:
        return sets_list[0], reps_list[0] + 2, weight_list[0]
    
    # then we will increase the weight if the reps are at the max
    weight_increase = 0.075 * weight_list[0] # 7.5% increase

    return sets_list[0], base_reps, int(weight_list[0] + weight_increase)
    


            
def get_recommendation(userId):

    userRef = db.collection('users').document(userId)
    userWorkoutHistory = userRef.collection('workoutHistory').order_by("date", direction=firestore.Query.DESCENDING).stream()
    allExercises = db.collection('exercises').where(filter=FieldFilter("muscleGroups", "array_contains_any", ["Quads"])).stream()

    user = userRef.get()
    user_weight = user.get('weight')

    # combine userWorkoutHistory and allExercises to generate scores for each exercise according to history
    # then return the top 5 exercises

    exercise_dict = {}
    for exercise in allExercises:
        # store the exercise, scores, sets, reps, weights, and dates
        exercise_dict[exercise.id] = (exercise, [], [], [], [], [])

    for workout in userWorkoutHistory:
        # get the exercise and the sets, reps, and weight
        exercise = workout.get('exercise')

        if exercise.id not in exercise_dict:
            continue
        
        score = workout.get('score')
        sets = workout.get('sets')
        reps = workout.get('reps')
        weight = workout.get('weight')
        date = workout.get('date')

        # add the sets, reps, and weights to the exercise
        exercise_dict[exercise.id][1].append(score)
        exercise_dict[exercise.id][2].append(sets)
        exercise_dict[exercise.id][3].append(reps)
        exercise_dict[exercise.id][4].append(weight)
        exercise_dict[exercise.id][5].append(date)

    # score the exercises based on the history
    # print(exercise_dict)
    exercises_scored = []

    for exercise_id in exercise_dict.keys():
        score = calculate_score(exercise_dict[exercise_id][1], exercise_dict[exercise_id][5])

        bwRatiosDict = exercise_dict[exercise_id][0].get('baseParams').get('bodyWeightRatio')
        bwRatio = bwRatiosDict.get('male')
        if user.get('sex').lower() == 'female':
            bwRatio = bwRatiosDict.get('female')

        sets, reps, weight = calculate_sets_reps_weight(
            exercise_dict[exercise_id][2],
            exercise_dict[exercise_id][3],
            exercise_dict[exercise_id][4],
            exercise_dict[exercise_id][5],
            user_weight * bwRatio
        )

        exercises_scored.append((exercise_dict[exercise_id][0], score, sets, reps, weight))

    return sorted(exercises_scored, key=lambda x: 6 if x[1] == 0 else x[1], reverse=True)

def run_rec_and_do():
    recomendations = get_recommendation(CURUSER)

    for rec in recomendations:
        # print the exercise name, score, sets, reps, and weight
        print(rec[0].get("name"), rec[1], rec[2], rec[3], rec[4])

    return 

    
    # do the exercises
    for exercise in recomendations[:3]:
        workout_done = {
            'exercise': exercise[0].reference,
            'sets': exercise[2],
            'reps': exercise[3],
            'weight': exercise[4],
            'duration': random.randint(60, 300),
            'score': int(input("Enter the score for " + exercise[0].get("name") + ": ")),
            'date': datetime.datetime.now(tz=datetime.timezone.utc)
        }
        userRef = db.collection('users').document(CURUSER)
        userRef.collection('workoutHistory').add(workout_done)

run_rec_and_do()

# get_recommendation(CURUSER)


