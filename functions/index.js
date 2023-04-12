const functions = require("firebase-functions");

//  admin.initializeApp();

exports.testing = functions.https.onCall((data, context) => {
  const test = data.test;
  const msgtkn = data.msgtkn;
  // const { test, msgtkn } = data;

  console.log(test);
  console.log(msgtkn);
});
