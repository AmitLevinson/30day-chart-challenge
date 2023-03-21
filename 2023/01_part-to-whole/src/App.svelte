
<script>
  import { onMount } from 'svelte';
  // import Pie from './lib/Pie.svelte';
  /* inspired form https://svelte.dev/repl/e68bcf378d2c410d9c123fd309fc6dbb?version=3.42.4 */

  let store = 0;
  let percentage = 0;
  let currentTime;
  let size = 400;
  

  let bgColor = 'gray';
  let fgColor = '#32408F';

  
  $: radius = size / 2;
  $: halfCircumference = Math.PI * radius;
  $: pieSize = halfCircumference * (store);
  $: dashArray = `0 ${halfCircumference - pieSize} ${pieSize}`;
  
  $: store, percentage;



  onMount(returnTime)

  function returnTime () {
    const now = new Date();
    let time = now;
  
    const sod = new Date()
    let startOfDay = sod.setUTCHours(0,0,0,0)
  
    const eod = new Date()
    let endOfDay = eod.setUTCHours(23,59,59,999)
  
    currentTime = time.getHours() + ":" + (time.getMinutes() < 10 ? "0" + time.getMinutes() : time.getMinutes()) + ":"
                   + (time.getSeconds() < 10 ? "0" + time.getSeconds() : time.getSeconds()) ;
    store = (time - startOfDay) / (endOfDay - startOfDay);
    percentage = (store * 100).toFixed(1)
    // store = actualTime.percentPassed;
  }
  
  
  var intervalID = window.setInterval(function () {
    returnTime() 
   }, 1000)


</script>

<h1><span id='percentage'>You completed {percentage}%</span> of the day</h1>
<br>
<h2>⌚ {currentTime}</h2>
<div class="chart" bind:clientWidth={size}>
<br>
<svg width={size} height={size}>
  <circle r={radius} cx={radius} cy={radius} fill={bgColor} />
  <circle
    r={radius / 2}
    cx={radius}
    cy={radius}
    fill={bgColor}
    stroke={fgColor}
    stroke-width={radius}
    stroke-dasharray={dashArray}/>
</svg>
<div class="footer">
  <a href='https://twitter.com/Amit_Levinson'>Amit Grinson</a> &#x2022; <a href ='https://twitter.com/30DayChartChall'>#30DayChartChallenge</a>
</div>
</div>
