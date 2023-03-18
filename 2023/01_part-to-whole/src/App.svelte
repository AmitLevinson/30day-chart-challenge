
<script>
  import { onMount } from 'svelte';
  import {spring, tweened} from 'svelte/motion';
  import Pie from './lib/Pie.svelte';
  /* inspired form https://svelte.dev/repl/e68bcf378d2c410d9c123fd309fc6dbb?version=3.42.4 */

  let currentTime = new Date();
  onMount(returnTime)
  
  let percent = 0;
  let store = 0;
  $: store;
  // const store = tweened(0, {duration: 1000});
  
  // $: store.set(actualTime.percentPassed)

  function returnTime () {
    const now = new Date();
    let time = now;
  
    const sod = new Date()
    let startOfDay = sod.setUTCHours(0,0,0,0)
  
    const eod = new Date()
    let endOfDay = eod.setUTCHours(23,59,59,999)
  
    currentTime = time;
    store = (time - startOfDay) / (endOfDay - startOfDay);
    // store = actualTime.percentPassed;
  }
  
  
  var intervalID = window.setInterval(function () {
    returnTime() 
    console.log(currentTime) 
   }, 1000)

</script>

<h1>{currentTime}
  <br>
    {store * 100}
</h1>
<Pie size={400} percentPassed={store} />