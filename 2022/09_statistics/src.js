// Starter: http://bl.ocks.org/phil-pedruco/88cb8a51cdce45f13c7e

var data = [];

let solution = d3.select('.solution')
let retry = d3.select('.retry')

var arrDeviations = [0.25, 0.5, 0.75, 1]

const randomDeviation = arrDeviations[Math.floor(Math.random() * arrDeviations.length)]
console.log(`You hacker! Well then, here's your answer: ${randomDeviation}`)

getData(data, arrDeviations);


var margin = {
    top: 20,
    right: 20,
    bottom: 50,
    left: 50
},
width = 550 - margin.left - margin.right
height = 250 - margin.top - margin.bottom


const svg = d3.select("#wrapper")
    .append('svg')
    .attr('preserveAspectRatio', 'xMinYMid meet')
    .attr('viewBox', '0 0 ' + (width+margin.left + margin.right) + ' ' + (height + margin.top + margin.bottom))
    
bounds = svg.append('g')
        .attr("transform", "translate(" +margin.left + "," +margin.top + ")");

    var xAccessor = d => d.q
    var yAccessor = d => d.p

    var xScale = d3.scaleLinear()
        .domain([-4,4])
        .range([0, width])

    var xAxisGenerator = d3.axisBottom()
        .scale(xScale)


    var xAxis = bounds.append('g')
        .call(xAxisGenerator)
        .style("transform", `translateY(${height}px)`)


    var yScale = d3.scaleLinear()
        .range([height, 0 ])
        .domain(d3.extent(data.map(yAccessor)))

    // var yAxisGenerator = d3.axisLeft()
    //     .scale(yScale)

    // var yAxis = bounds.append('g')
        // .call(yAxisGenerator)
        

    var lineGenerator = d3.line()
        .x(d => xScale(xAccessor(d)))
        .y(d => yScale(yAccessor(d)))

    DrawLine = bounds.append('path')
        .attr("d", lineGenerator(data))
        .attr("fill", "none")
        .attr("stroke", "black")
        .attr("stroke-width", 1)

    // Buttons
    const docButtons = document.getElementById('buttons')
    docButtons.addEventListener('click', (event) => {
        const isButton = event.target.nodeName == "BUTTON";
        if (!isButton) {
            return;
        }
        clickedVal = event.target.textContent;
        isCorrect = event.target.textContent == randomDeviation;
        solution.append('text')
            .text(isCorrect ? "Correct!" : "Wrong :(")
            .style("color", isCorrect ? "green" : "red")
        
    docButtons.remove()
    retry.style("display", "block")
        
    })
    

function getData(dataframe) {
    for (var i = 0; i < 1000; i ++) {
        q = normal()
        p = gaussian(q, sigma = randomDeviation)
        el = {
            "q": q,
            "p": p
        }
        dataframe.push(el)
    };

    dataframe.sort((x,y) => x.q-y.q)
    dataframe.forEach((d, i) => {
        d.rowNum = i
        d.p = +d3.format(".4f")(d.p)

    })
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
function gaussian(x, sigma) {
	var gaussianConstant = 1 / Math.sqrt(2 * Math.PI),
		mean = 0,
    	sigma = sigma;

    x = (x - mean) / sigma;
    return gaussianConstant * Math.exp(-.5 * x * x) / sigma;
};