<script>
  /* inspired from https://svelte.dev/repl/e68bcf378d2c410d9c123fd309fc6dbb?version=3.42.4 */
  /* Svelte project template from https://github.com/connorrothschild/svelte-visualization-template */
  import Legend from './Legend.svelte';

  let store = 0;
  let percentageDisplay = 0;
  let currentTime;
  let size = 500;
  

  let bgColor = 'gray';
  let fgColor = '#32408F';

  
  $: radius = size / 2;
  $: halfCircumference = Math.PI * radius;
  $: pieSize = halfCircumference * (store);
  $: dashArray = `0 ${halfCircumference - pieSize} ${pieSize}`;
  $: store, percentageDisplay;

  function returnTime () {
    const now = new Date();
    let time = now;
  
    const sod = new Date()
    sod.setHours(0,0,0,0)

    const eod = new Date()
    eod.setHours(23,59,59,999)
  
    currentTime = time.getHours() + ":" + (time.getMinutes() < 10 ? "0" + time.getMinutes() : time.getMinutes()) + ":"
                   + (time.getSeconds() < 10 ? "0" + time.getSeconds() : time.getSeconds()) ;
    store = (time - sod) / (eod - sod);
    percentageDisplay = (store * 100).toFixed(1)
  }
  
  returnTime()  
  var intervalID = window.setInterval(function () {
    returnTime() 
   }, 1000)


</script>

<h1><span id='percentage'>You completed {percentageDisplay}%</span> out of a 24 hour day</h1>
<br>
<h2>⌚ {currentTime}</h2>
<div class="chart" bind:clientWidth={size}>
<br>
<div class="legend">
    <Legend legendWidth={20} legendHeight={12} legendStyle={'fill:#32408F;'} />
    Part of the day completed
    <br>
    <Legend legendWidth={20} legendHeight={12} legendStyle={'fill:gray;'} />
    What's left of the day
</div>
<br>
<svg width={size} height={size}>
  <circle r={radius} cx={radius} cy={radius} fill={bgColor}/>
  <circle
    r={radius / 2}
    cx={radius}
    cy={radius}
    fill={bgColor}
    stroke={fgColor}
    stroke-width={radius}
    stroke-dasharray={dashArray}
    />
</svg>
<div class="footer">
  <a href='https://twitter.com/Amit_Levinson'>Amit Grinson</a> &#x2022; <a href ='https://twitter.com/30DayChartChall'>#30DayChartChallenge</a>
</div>
</div>

