import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

exports.addMessage = functions.https.onRequest(async (req, resp) => {
  const original = req.query.text;
  const writeResult = await admin.firestore().collection("messages")
    .add({original: original});
  resp.json({result: `Message with ID: ${writeResult.id} added.`});
});

exports.addMessageCallable = functions.https.onCall(async (data: {
  text: string
}) => {
  const original = data.text;
  await admin.firestore().collection("messages")
    .add({original: original});
});

exports.makeUppercase = functions.firestore.document("/messages/{documentId}")
  .onCreate((snap, context) => {
    const original = snap.data().original;
    functions.logger
      .log("Uppercasing", context.params.documentId, original);

    const uppercase = original.toUpperCase();
    return snap.ref.set({uppercase}, {merge: true});
  });
