from flask import request, Flask, jsonify
# from google.auth.transport import requests
import firebase_admin
from firebase_admin import auth, credentials, firestore
import signal
import time
import relation
from relation import active_users
import requests



class Person:
    def __init__(self, id, text, devices):
        self.txt           = text       #TODO change all to text
        self.devices        = devices   #devices
        self.id             = id        #user's device ID



def setup():
    cred = credentials.Certificate("firebase.json")
    firebase_admin.initialize_app(cred)
    global timeout
    timeout = 60
    # header = "#User's ID ; devices in its proximity ; Speech; preferences"


def timeout(signum, frame):
    raise Exception("User not found in time")


app = Flask(__name__)

@app.before_request
def authenticate():
    if request.endpoint != 'unprotected':  # Exclude routes that don't require authentication
        id_token = request.headers.get('Authorization')
        if not id_token:
            return jsonify({'error': 'Authorization token missing'}), 401
        try:
            decoded_token = auth.verify_id_token(id_token[7:])
            # Attach the decoded token to the request for easy access
            request.id = decoded_token['uid']
        except auth.InvalidIdTokenError:
            return jsonify({'error': 'Invalid authorization token'}), 401


@app.route("/people", methods=["GET"])
def people():
    # Not implemented
    # TODO MUST BE IN A LOOP, OR RESTRUCTED IN TERMS OF FIREBASE ACCESS
    # return pull_data(["7EJ6BJLTdPcZx6707LmcRcnvjzU2"], 1)
    pass


@app.route("/get_contacts", methods=["GET"])
def pull_data():
    user_id     = request.id
    #Connect to Firebase and get
    fireb_db    = firestore.client()

    doc         = fireb_db.collection("profiles").document(user_id).get()
    ids         = doc.get("relations_ids")
    types       = doc.get("relations_types") 

    profiles    = []
    for i, id in enumerate(ids):
        doc     = fireb_db.collection("profiles").document(id).get() #id of interlocutor

        profile = {}
        if doc.exists:
            doc = doc.to_dict()
            for field in doc:
                if field != 'relations_ids' and field != 'relations_types':
                    if int(doc[field][1]) <= types[i] : #type of relation
                        profile[field] = doc[field][0]
        else:
            #Raise exception ? - user does not exist
            pass
        profiles.append(profile)

    print(jsonify(profiles).json)

    return jsonify(profiles)

def push_ids(id, relations_id, relations_type):
    fireb_db    = firestore.client()
    doc = fireb_db.collection("profiles").document(id)
    get_doc = doc.get().to_dict()
    for type in get_doc['relations_types']:
        relations_type.append(type)
    for id in get_doc['relations_ids']:
        relations_id.append(id)
    doc.set({"relations_ids" : relations_id}, merge=True)
    doc.set({"relations_types" : relations_type}, merge=True)


#We call main upon post request through which we send the speech data and proximity
@app.route("/input", methods=["POST"])
def main():
    setup()
    id      = request.id
    text    = request.json.get('text')
    devices = request.json.get('devices')
    person  = Person(id, text, devices)


    # id      = request.id
    # text    = request.json.get('text')
    # devices = request.json.get('devices')

    #test @TODO delete
    # id      = 'test'
    # text    = 'hey what is up? I am great how are you? yeah it has been raining all day, but I managed to get it done.'
    # devices = ['clacla', ] #7EJ6BJLTdPcZx6707LmcRcnvjzU2
    # person  = Person(id, text, devices)

    # test @TODO delete
    id      = 'test'
    text    = 'hey what is up? I am great how are you? ok bye'
    devices = ['clacla', ] #7EJ6BJLTdPcZx6707LmcRcnvjzU2
    person  = Person(id, text, devices)
    person = Person("7EJ6BJLTdPcZx6707LmcRcnvjzU2","I love you",["ZH1CR9Y36kWHIZPQtGkUikvIrSu2","ANOTHER_DEVICE","YET_ANOTHER_DEVICE"])
    # test #
    
    active_users.append(person)

    related_people = relation.match_devices(person)

    if related_people == None: return 'new', 200

    # with open('active_users.csv', 'a') as usr_db:
    #     for line in usr_db:
    #         if line.strip()[0] == '#':
    #             continue
    #         id, devices, text, pref = line.split(';')

    # signal.signal(signal.SIGALRM, timeout)
    # signal.alarm(timeout)
    # try:
    #     while True:
    #         related_people = relation.match_devices(person)
    #         time.sleep(1)
    #         if related_people != None:
    #             break
    # except Exception:
    #     return None

    relations_types    = []
    relations_id       = []
    for interlocutor in related_people:
        conversation = relation.build_conversation(person, interlocutor)
        relations_status = relation.analyze_relationship(conversation)
        if int(relations_status[0]) > 0:
            relations_id.append(interlocutor.id)
            relations_types.append(relations_status[0])
    push_ids(person.id, relations_id, relations_types)

    return 'ok', 200


# def get_song(user_and_key):
#     user, api_key  = user_and_key.split(',')
#
#     # Get request
#     response = requests.get(f"https://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user={user}&api_key={api_key}&format=json&limit=1")
#     body = response.json()
#
#     if not body:
#         return None
#
#     latest_song = body["recenttracks"]["track"][0]
#
#     if not latest_song or not latest_song["name"]:
#         return None
#
#     return latest_song["name"]

####################    test   ################

setup()
# #print(pull_data('test'))

# # (pull_data('test'))
# # data = [[1, 2, 3],[0,0,0]]

# data = [["a",1], ["b", 2]]
# # print(data[:,0])
# # print(push_ids('test', ['a','b','c'], [1,2,3])) #TODO not work
# # pull_data([('test',1)])
# print('\ncheckpoint')


# # active_users.append(Person("7EJ6BJLTdPcZx6707LmcRcnvjzU2","I love you",["ZH1CR9Y36kWHIZPQtGkUikvIrSu2","ANOTHER_DEVICE","YET_ANOTHER_DEVICE"]))
active_users.append(Person("UNRELATED_DEVICE","bla bla",["YET_ANOTHER_DEVICE,ZH1CR9Y36kWHIZPQtGkUikvIrSu2,7EJ6BJLTdPcZx6707LmcRcnvjzU2"]))
active_users.append(Person("ZH1CR9Y36kWHIZPQtGkUikvIrSu2","I love you",["YET_ANOTHER_DEVICE","7EJ6BJLTdPcZx6707LmcRcnvjzU2"]))

print(main())
################################################

