<script>
import {scaleBand, scaleLinear} from 'd3-scale';
import {max} from 'd3-array';
import AxisY from './AxisY.svelte';
import AxisX from './AxisX.svelte'

export let allData;

let width = 700;
let height = 500;

let margin = {top: 20, right: 20, bottom: 20, left: 180}
let innerHeight = height - margin.top - margin.bottom
let innerWidth = width - margin.left - margin.right

$: xAccessor = allData.map((d) => d.views)
$: yAccessor = allData.map((d) => d.article_clean)

$: xScale = scaleLinear()
    .domain([0,  max(xAccessor)])
    .range([0, innerWidth]);

$: yScale = scaleBand()
  .range([0,innerHeight])
  .domain(yAccessor)
  .padding(0.1);

$: categories = allData.map(d=> d.article_clean);


</script>
<svg {width} {height}>
    <AxisY yScale={yScale} margin={margin} {categories} />
    <AxisX xScale={xScale} innerHeight={innerHeight} width={width} margin={margin} />
    <g transform = {`translate(${margin.left}, ${margin.top})`}>
        {#each allData as d, index}
            <rect 
                x = "0"
                y = {yScale(d.article_clean)}
                width = {xScale(d.views)}
                height = {yScale.bandwidth()}
                fill ='#006400'
            />
        {/each}
    </g>
</svg>
