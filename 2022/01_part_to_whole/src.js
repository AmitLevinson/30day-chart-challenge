const margin = {top: 10, right: 30, bottom: 20, left: 50},
    width = 400 - margin.right - margin.left;
    height = 360 - margin.top - margin.bottom;

var svg = d3.select("#wrapper")
    .append("svg")
    .attr('preserveAspectRatio', "xMinYMin meet")
    .attr("viewBox", '0 0 ' + (width+margin.left + margin.right) + " " + (height + margin.top + margin.bottom))

    xScale = d3.scale.linear()
        .range([0, width])

    
function drawChart () {
    d3.csv("packages.csv", function (data) {
    packages = data.slice(0,10)
        console.log(packages);
        var y0 = d3.scale.ordinal()
            .rangeBands([height, 0], 0)
            .domain()
    }
    )}

drawChart();