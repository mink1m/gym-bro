import csv
from firebase_admin import credentials
from firebase_admin import firestore
import firebase_admin
from pathlib import Path
import os
import glob



cred = credentials.Certificate("./firebase/serviceAccountKey.json")

app = firebase_admin.initialize_app(cred)

db = firestore.client()

def getFilePath() -> list:
    '''Returns a list of CSV files in cwd that need to be added to the DB'''
    return [Path(os.getcwd()) / filename for filename in glob.glob('*.csv')]

def parseFiles(csvFiles: list) -> None:
    '''parse and upload file stuff from csv documents'''
    for file in csvFiles:
        parseFile(file)

def parseFile(filePath: Path) -> None:
    '''parse the specific file given to send to the workout firebase'''
    with open(filePath, mode='r') as file:
        csv_reader = csv.DictReader(file)

        for row in csv_reader:
            row['muscleGroups'] = parseMuscleGroups(row['Muscle Group'])
            row['type'] = row['Type']
            row['image'] = None
            row['bodyWeightRatio'] = 0.0
            row['name'] = row['Workout Name']
            row['description'] = row['Description']
            del row['Type']
            del row['Muscle Group']
            del row['Description']
            del row['Workout Name']
            sendtoFireBase(row)

def parseMuscleGroups(muscleGroup):
    '''Returns muscle groups split by a /'''
    return muscleGroup.split('/')

def sendtoFireBase(elementDict):
    '''send the specific item to the firebase'''
    db.collection('exercises').add(elementDict)
    











if __name__ == "__main__":
    #get list of csv file paths
    csvFiles = getFilePath()
    #parse files and 
    parseFiles(csvFiles)




