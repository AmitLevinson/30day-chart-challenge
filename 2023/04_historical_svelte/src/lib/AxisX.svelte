<script>
    export let xScale;
    export let innerHeight;
    export let width;
    export let margin;
    import {format} from 'd3-format';

    $: xTicks = xScale.ticks(3)
    $: console.log(xTicks.length)
    const formatComma = format(',');


</script>

<g class="axis x" transform="translate({0}, {innerHeight +margin.top})">
  <line x1={180} y1={0} x2={width} y2={0} stroke="black"/>
  <!-- <text x={width - margin.right} y = {6} dy = 9 dominant-baseline="middle" text-anchor='middle'>צפיות</text> -->
  {#each xTicks as tick, i}
      <g class='tick' transform='translate({xScale(tick)}, 0)'>
          <line x1={180} y1={0} x2={180} y2={6} stroke="black"/>
          <text x={180} y={6} dy={9} dominant-baseline="middle" text-anchor='middle'>{i == xTicks.length-1 ? `${formatComma(tick)} צפיות` : formatComma(tick)
          }</text>
      </g>
  {/each}
  <text class="axis-title" y={-9} x={width} text-anchor="end">
      Final Grade →
  </text>
</g>


<style>
  text {
    direction: rtl;
  }
</style>
