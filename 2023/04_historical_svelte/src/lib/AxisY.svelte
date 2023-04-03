<script>
    export let yScale;
    export let margin;
    export let categories;
</script>

<g class="axis-y" transform="translate(0, {margin.bottom})">
  {#each categories as text, index}
    <g class='ticks'>
    <text x ={175} y={yScale(text) + (yScale.bandwidth()/ 2)} dy='.25em'>{text}</text>
    </g>
  {/each}
</g>

<style>

</style>
