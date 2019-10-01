// Firebase App (the core Firebase SDK) is always required and
// must be listed before other Firebase SDKs
var firebase = require("firebase/app");

// Add the Firebase products that you want to use
// require("firebase/auth"); FIXME LATER
require("firebase/database");

var firebaseConfig = {
  apiKey: "AIzaSyBXu_Syy8_qCoKfIf60zgLbrwb1C-tvI1Y",
  authDomain: "oso-ari.firebaseapp.com",
  databaseURL: "https://oso-ari.firebaseio.com",
  projectId: "oso-ari",
  storageBucket: "",
  messagingSenderId: "1091936025420",
  appId: "1:1091936025420:web:f761ace88686682bc5ede9"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

var serialId = "SERIAL_ID_TO_BE_FILLED";

// Presence process
var recorderPresence = firebase.database().ref("presence/recorder");
var historyRef = recorderPresence.child("history/" + serialId);
var statusRef = recorderPresence.child("status/" + serialId);

var connectedRef = firebase.database().ref(".info/connected");
connectedRef.on("value", function(snap) {
  if (snap.val() === true) {
    statusRef
      .onDisconnect()
      .set({ online: false, ts: firebase.database.ServerValue.TIMESTAMP });
    statusRef.set({
      online: true,
      ts: firebase.database.ServerValue.TIMESTAMP
    });

    // Log connection history
    var history = historyRef.push();
    history.set({ start: firebase.database.ServerValue.TIMESTAMP, end: null });
    history
      .child("end")
      .onDisconnect()
      .set(firebase.database.ServerValue.TIMESTAMP);
  }
});
