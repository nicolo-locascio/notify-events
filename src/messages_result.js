var commons = require("../../commons/src/commons");

const conf = commons.merge(require('./conf/events'), require('./conf/events-' + (process.env.ENVIRONMENT || 'localhost')));
console.log(conf);
const obj = commons.obj(conf);

const logger = obj.logger("status");
const db = obj.db();
const Utility = obj.utility();
const queryBuilder = obj.query_builder();
const security_checks = obj.security_checks();
var prefix = "/api/v1/";
var bodyParser = require('body-parser');
const util = require("util");

var express = require('express');
var app = express();

app.use(bodyParser.json());
app.use(function(req, res, next) {
  res.set("X-Response-Time", new Date().getTime());
  next();
});
const dateformat = require("dateformat");
var to_continue_insert = true;

if (conf.security) {
  if (conf.security.blacklist) obj.blacklist(app);

  var permissionMap = [];
  permissionMap.push({
    url: prefix + "status/messages",
    method: "get",
    permissions: ["read"]
  });
  permissionMap.push({
    url: prefix + "status/messages/:message_id",
    method: "get",
    permissions: ["read"]
  });

  obj.security(permissionMap, app);
}

app.get(prefix + 'status/messages/', async function(req, res, next) {

  let bulk_id = req.query.bulk_id;
  if(!bulk_id) return next({type: "client_error",status: 400,message: "Bulk_id param is mandatory"});
  try {
    let select_query = queryBuilder.select("message_id, bulk_id, email_result::int, push_result::int, sms_result::int, io_result::int, mex_result::int, send_date, note").table("messages_status").filter({
      "bulk_id": {
        "eq": bulk_id
      }
    }).sql;
    var select_result = await db.execute(select_query);

    if (select_result.length === 0) return next({
      type: "client_error",
      status: 204,
      message: "No data found"
    })

    return next({
      type: "ok",
      status: 200,
      message: select_result
    });

  } catch (err) {
    return next({
      type: "system_error",
      status: 500,
      message: err
    });
  }
});

app.get(prefix + 'status/messages/:message_id', async function(req, res, next) {
  let message_id = req.params.message_id;
  try {
    let select_query = queryBuilder.select("message_id, bulk_id, email_result::int, push_result::int, sms_result::int, io_result::int, mex_result::int, send_date, note").table("messages_status").filter({
      "message_id": {
        "eq": message_id
      }
    }).sql;

    let select_result = (await db.execute(select_query))[0];
    if(!select_result) return next({
      type: "client_error",
      status: 204,
      message: "No data found"
    });
    return next({
      type: "ok",
      status: 200,
      message: select_result
    });

  } catch (err) {
    logger.error(err);
    return next({
      type: "system_error",
      status: 500,
      message: err
    });
  }
});

obj.response_handler(app);

app.listen(conf.server_port, function() {
  logger.info("environment: ");
  logger.info(JSON.stringify(process.env, null, 4));
  logger.info("configuration: ");
  logger.info(JSON.stringify(conf, null, 4));
  logger.info('Express server preferences listening on port: ', conf.server_port);

});
