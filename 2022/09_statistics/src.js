// Starter: http://bl.ocks.org/phil-pedruco/88cb8a51cdce45f13c7e

var data = [];

getData();

var margin = {
    top: 20,
    right: 20,
    bottom: 30,
    left: 50
},
width = 500 - margin.left - margin.right
height = 200 - margin.top - margin.bottom


const svg = d3.select("#wrapper")
    .append('svg')
    .attr('preserveAspectRatio', 'xMinYMid meet')
    .attr('viewBox', '0 0 ' + (width+margin.left + margin.right) + ' ' + (height + margin.top + margin.bottom))
    
bounds = svg.append('g')
        .attr("transform", "translate(" +margin.left + "," +margin.top + ")");

    var xAccessor = d => d.q
    
    var xScale = d3.scaleLinear()
        .domain(xAccessor)
        .range([0, width])

    var xAxisGenerator = d3.axisBottom()
        .scale(xScale)


    var xAxis = bounds.append('g')
        .call(xAxisGenerator)
        .style("transform", `translateY(${height}px)`)

        
    yScale = d3.scaleLinear()
        .range([height, 0 ])
        .domain([0, 0.01])



    var yAxis = d3.axisLeft()
        .scale(yScale)




function getData() {
    for (var i = 0; i < 10000; i ++) {
        q = normal()
        p = gaussian(q)
        el = {
            "q": q,
            "p": p
        }
        data.push(el)
    };

    data.sort((x,y) => x.q-y.q)
}



function normal() {
    var x = 0,
        y = 0,
        rds, c;
    do {
        x = Math.random() * 2 - 1;
        y = Math.random() * 2 - 1;
        rds = x * x + y * y;
    } while (rds == 0 || rds > 1);
    c = Math.sqrt(-2 * Math.log(rds) / rds); // Box-Muller transform
    return x * c; // throw away extra sample y * c
}

//taken from Jason Davies science library
// https://github.com/jasondavies/science.js/
function gaussian(x) {
	var gaussianConstant = 1 / Math.sqrt(2 * Math.PI),
		mean = 0,
    	sigma = 1;

    x = (x - mean) / sigma;
    return gaussianConstant * Math.exp(-.5 * x * x) / sigma;
};
