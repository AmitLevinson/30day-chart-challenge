
<script>
  import { onMount } from 'svelte';
  import Pie from './lib/Pie.svelte';
  /* inspired form https://svelte.dev/repl/e68bcf378d2c410d9c123fd309fc6dbb?version=3.42.4 */

  let store = 0;
  let percentage = 0;
  let currentTime;
  let size = 300
  $: store, percentage, size;

  onMount(returnTime)

  function returnTime () {
    const now = new Date();
    let time = now;
  
    const sod = new Date()
    let startOfDay = sod.setUTCHours(0,0,0,0)
  
    const eod = new Date()
    let endOfDay = eod.setUTCHours(23,59,59,999)
  
    currentTime = time.getHours() + ":" + (time.getMinutes() < 10 ? "0" + time.getMinutes() : time.getMinutes()) + ":" + time.getSeconds();
    store = (time - startOfDay) / (endOfDay - startOfDay);
    percentage = (store * 100).toFixed(1)
    // store = actualTime.percentPassed;
  }
  
  
  var intervalID = window.setInterval(function () {
    returnTime() 
   }, 1000)

</script>

<h1>It's now {currentTime}, we completed <span id='percentage'>{percentage}%</span> of the day</h1>
<br>
<Pie  size={size} percentPassed={store} />