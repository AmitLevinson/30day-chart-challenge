export function returnTime (currentTime,store,  percentage) {
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
  