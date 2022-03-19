


// Both are valid
// d3.csv("packages.csv").then(function(data) {

//     data.forEach(function(d) {
//         d.n = +d.n;
//         d.pct = +d.pct;
//         d.total_scripts = +d.total_scripts;
//       });
    
//     cleandat = data.slice(0,10)
//     console.table(cleandat)

//   });
    
  const margin = {top: 10, right: 50, bottom: 20, left: 50},
  width = 550 - margin.right - margin.left;
  height = 250 - margin.top - margin.bottom;
  var barHeight = 20;    

  var svg = d3.select("#wrapper")
    .append("svg")
    .attr('preserveAspectRatio', "xMinYMid meet")
    .attr("viewBox", '0 0 ' + (width+margin.left + margin.right) + " " + (height + margin.top + margin.bottom))
      
  bounds = svg.append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

async function drawChart () {

  const data = await d3.csv("packages.csv");
  data.forEach(function(d) {
    d.n = +d.n;
    d.pct = +d.pct;
    d.total_scripts = +d.total_scripts;
  });

  cleandat = data.slice(0,10)
  cleandat.sort((x, y) => {
    return d3.ascending(x.pct, y.pct)
  })

  xScale = d3.scaleLinear()
      .range([0, width])
      .domain([0, 1])

  yScale = d3.scaleBand()
      .domain(cleandat.map(d => d.package))
      .range([height, 0])
      
console.log([cleandat.map(d => d.package)])

  console.log(yScale('t'))

  var yAxis = d3.axisLeft()
    .scale(yScale)
  

  
  var xAxis = d3.axisBottom()
    .scale(xScale)

  var formatPct = d3.format(".0%")
    // .tickFormat(d => (d == 0) ? d + "%" : d * 100 + "%")
  
  // svg.append("g")
  //   .attr("class", "x axis")
  //   // .attr("transform", "translate(0," + height + ")")
  //   .call(xAxis)

  // bind data to the bars
  var categoryGroup = svg.selectAll('.g-categories')
    .data(cleandat)
    .enter()
    .append('g')
    .attr('class', 'g-categories')
    .attr('transform', function (d) {
     return "translate(0," + yScale(d.package) + ")";
    })

  // gray background
  var barsBackground = categoryGroup.append('rect')
    .attr('width', xScale(1))
    .attr("height", barHeight)
    .attr("class", "g-num2")
    // .attr("transform", "translate(0,4)")
    
    // Main bars
    var bars = categoryGroup.append('rect')
    .attr("width", function(d) {return xScale(d.pct);})
    .attr("height", barHeight)
    .attr('class', 'g-num')
    // .attr("transform", "translate(0,4)")
    
    // Background bars
    
    var labelGroup = svg.selectAll("g-num")
      .data(cleandat)
      .enter()
      .append("g")
      .attr("transform", d => "translate (0, 14)")
        .append("text")
        .html(d => `${d.package} (${formatPct(d.pct)})`) 
        .attr("x", d => xScale(0.001))
        .attr("y", d => yScale(d.package))
        .attr("class", "g-labels")
    // svg.selectAll('.g-categories')
    // .data(cleandat)
    // .enter()
    // .append('text')
    // .attr("transform", "translate(0,15)")
    // .style("fill", 'white')
    // .text(d => d.package)
    console.log(labelGroup)
    // categoryGroup.append("text")
      

    d3.select(window).on("resize", function() {
      const newWidth = d3.select("svg").style("width");
      const newFontSize = 10 * (600 / parseInt(newWidth));
      d3.selectAll(".tick").select("text")
        .style("font-size", newFontSize)
    })
}

drawChart();

// Help from
// http://bl.ocks.org/jadiehm/7cc6b821d3df14280f33