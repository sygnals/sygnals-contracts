
function getEventLogs(result, eventName) {
  return result.logs.filter((log) => log.event === eventName);
}

Object.assign(exports, {
  getEventLogs
})