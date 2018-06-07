const config = require('./config.json');
const service = require('./client_secret.json');
const { google } = require('googleapis');
const pubsub = google.pubsub({
    version: 'v1',
    auth: new google.auth.JWT(
      service.client_email,
      './client_secret.json',
      null,
      ['https://www.googleapis.com/auth/pubsub'])
  });

/**
 * Log event info.
 *
 * @param {object} req Cloud Function request context.
 */
function logEvent(req) {
  console.log(`HEADERS ${JSON.stringify(req.headers)}`);
  return req;
}

/**
 * Parse event payload.
 *
 * @param {object} req Cloud Function request context.
 */
function parsePayload(req) {
  return new Promise((resolve, reject) => {
    try {
      console.log(`PAYLOAD ${req.body.payload}`);
      resolve(JSON.parse(req.body.payload));
    } catch(err) {
      reject(err);
    }
  });
}

/**
 * Verify request contains proper validation token.
 *
 * @param {object} payload Slack payload.
 */
function verifyToken(payload) {
  // Verify token
  if (!payload || payload.token !== config.slack.verification_token) {
    const error = new Error('Invalid Credentials');
    error.code = 401;
    throw error;
  }
  return payload;
}

/**
 * Publish event to PubSub topic (if it's not a retry).
 *
 * @param {object} payload Slack payload.
 */
function publishEvent(payload) {
  return pubsub.projects.topics.publish({
      topic: `projects/${config.google.project}/topics/${payload.callback_id}`,
      resource: {
        messages: [
          {
            data: Buffer.from(JSON.stringify(payload)).toString('base64')
          }
        ]
      }
    })
    .then((pub) => {
      console.log(`PUB/SUB ${JSON.stringify(pub.data)}`);
      return payload;
    });
}

/**
 * Send OK HTTP response back to requester.
 *
 * @param {object} res Cloud Function response context.
 */
function sendResponse(res) {
  console.log('OK');
  res.send();
}

/**
 * Send Error HTTP response back to requester.
 *
 * @param {object} err The error object.
 * @param {object} res Cloud Function response context.
 */
function sendError(err, res) {
  console.error(err);
  res.status(err.code || 500).send(err);
  return Promise.reject(err);
}

/**
 * Responds to any HTTP request that can provide a "message" field in the body.
 *
 * @param {object} req Cloud Function request context.
 * @param {object} res Cloud Function response context.
 */
exports.publishEvent = (req, res) => {
  // Respond to Slack
  Promise.resolve(req)
    .then(logEvent)
    .then(parsePayload)
    .then(verifyToken)
    .then(publishEvent)
    .then((payload) => sendResponse(res))
    .catch((err) => sendError(err, res));
}
