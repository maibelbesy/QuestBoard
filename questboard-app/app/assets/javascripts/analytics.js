function queryAnalytics() {
  var keenClient = new Keen({
    projectId: "553e50d296773d66ebe3d8a1",   // String (required always)
    writeKey: "0c94a97409a33626937e8068934a664b60d136e0531bcb56f3b14e1d83dfe1235ace7cbda2dc5a4e3882a0a25a0b621626909536884b894fa860599420c22ecdcd09a8921aa777217aa46d1432a676c11c14cd2e53c12997c3cde78147e17640d1295ea17002c55a10f631075ed9af05",     // String (required for sending data)
    readKey: "04b1c1d473ea426c9bbdeed886b7dcf5a22efc9a9263a5a79159d3f0791087a6a406a44bf78d88f6a1742d7838d96ea311552dac3cc3edbd17107cc2b7c94b7d58e5c38e9a8f9a610cbae54cfc051c7ea5746ea47d29141146285acf19f6b6c28d33e40e9b84eb2c04da0ead1084e62d",       // String (required for querying data)
    protocol: "https",              // String (optional: https | http | auto)
    host: "api.keen.io/3.0",        // String (optional)
    requestType: "jsonp"            // String (optional: jsonp, xhr, beacon)
  });

  var visitor_origins = new Keen.Query("count", {
    eventCollection: "gender",
    groupBy: "gender"
  });

  keenClient.draw(visitor_origins, document.getElementById("count-pageviews-piechart"), {
    chartType: "piechart",
    title: "Quest Completion by Gender"
  });

  var visitor_origins1 = new Keen.Query("count", {
    eventCollection: "quest_type",
    groupBy: "self_assigned"
  });
  keenClient.draw(visitor_origins1, document.getElementById("count1-pageviews-piechart"), {
    chartType: "piechart",
    title: "Quest Completion by Assignment"
  });

  var count = new Keen.Query("count", {
    eventCollection: "sign_ups"
  });

  keenClient.draw(count, document.getElementById("count2-pageviews-metric"), {
    chartType: "metric",
    title: "Total Users",
    colors: ["#49c5b1"]
  });
}