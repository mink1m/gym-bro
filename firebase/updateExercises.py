import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import datetime
import json
from google.cloud.firestore import FieldFilter
import random
import csv
import argparse

cred = credentials.Certificate("./serviceAccountKey.json")

app = firebase_admin.initialize_app(cred)

db = firestore.client()


# reads the csv file inputed as an argument and updates the exercises collection in the database

def update_exercises(file):
    with open(file) as f:
        csv_data = csv.reader(f)

        all_exercises = {}

        for row in csv_data:
            if row[0] == "Workout Name":
                continue
            exercise = {
                "name": row[0],
                "image": row[6]
            }
            all_exercises[exercise["name"]] = exercise
        
        exercise_data = db.collection('exercises').stream()
        for exercise in exercise_data:
            exercise_ref = db.collection('exercises').document(exercise.id)
            exercise_ref.update({
                # "bwRatio": firestore.DELETE_FIELD, 
                # "bodyWeightRatio": firestore.DELETE_FIELD,
                "image": all_exercises[exercise.get("name")]["image"]
                })
        

def parse_arguments():
    parser = argparse.ArgumentParser(description='Update exercises in the database')
    parser.add_argument('file', type=str, help='The file to read the exercises from')
    return parser.parse_args()

def main():
    args = parse_arguments()
    update_exercises(args.file)

if __name__ == '__main__':
    main()