<script>
  import { onMount } from 'svelte';
  import { csv } from 'd3-fetch';
  import BarChart from './lib/barChart.svelte';
  
  let allData = [];
  
  const getData = async () => {
      const res = await csv('./src/data/top_15.csv')
      allData = res
      allData.forEach(d => {
          d['views'] =+d['views'];
          d['article_clean'] = d['article'].replaceAll('_', ' ')
        });
        };

  onMount(getData());
</script>

<main>
  <div class="title">
    <h1><i class="fa-solid fa-magnifying-glass"></i> ערכי ויקיפדיה הנצפים ביותר עד כה לשנת 2023</h1>
    <h3>צפייה = ביקור בעמוד ויקיפדיה לאותו ערך.
      נכון לתאריך 01.04.2023
    </h3>
  </div>
  {#if allData}
  <BarChart {allData}/>
  {/if}
  <br>
  <br>
  <footer>*להוציא עמודים כמו 'עמוד ראשי', 'חיפוש' וכו'</footer>
</main>

<style>



</style>
