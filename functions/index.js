const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const fcm = admin.messaging();
const db = admin.firestore();

exports.whenChanged = functions.firestore
  .document("/Users/{userId}/episodeKeeping/{showId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    if (
      before["episode"] !== after["episode"] ||
      before["season"] !== after["season"]
    ) {
      db.collection("Users")
        .doc(context.params["userId"])
        .get()
        .then(async (snap) => {
          const data = snap.data();

          const message = {
            token: before["token"],
            notification: {
              title: `${before["name"]}`,
              body: data["language"] == "en_US" ? `New Episode` : "حلقه جديده",
              image: `https://www.themoviedb.org/t/p/w1280${before["pic"]}`,
            },
            data: {
              body: data["language"] == "en_US" ? `New Episode` : "حلقه جديده",
              payload: `{"action": "episode"}`,
            },
          };
          return fcm
            .send(message)
            .then((response) => {
              return {
                success: true,
                response: "successfully sent message " + response,
              };
            })
            .catch((error) => {
              console.log(error);
              return { error: error };
            });
        });
    } else if (
      before["nextEpisodeDate"] !== after["nextEpisodeDate"] ||
      before["nextSeason"] !== after["nextSeason"] ||
      before["nextepisode"] !== after["nextepisode"]
    ) {
      db.collection("Users")
        .doc(context.params["userId"])
        .get()
        .then(async (snap) => {
          const data = snap.data();

          const message = {
            token: before["token"],
            notification: {
              title: `${before["name"]}`,
              body:
                data["language"] == "en_US"
                  ? `Next Episode Date Is ${after["nextEpisodeDate"]}`
                  : `موعد الحلقه القادمه هو ${after["nextEpisodeDate"]}`,
              image: `https://www.themoviedb.org/t/p/w1280${before["pic"]}`,
            },
            data: {
              body:
                data["language"] == "en_US"
                  ? `Next Episode Date Is ${after["nextEpisodeDate"]}`
                  : `موعد الحلقه القادمه هو ${after["nextEpisodeDate"]}`,
              payload: `{"action": "episode"}`,
            },
          };
          return fcm
            .send(message)
            .then((response) => {
              return {
                success: true,
                response: "successfully sent message " + response,
              };
            })
            .catch((error) => {
              console.log(error);
              return { error: error };
            });
        });
    } else {
      return null;
    }
  });
