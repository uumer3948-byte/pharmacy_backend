async function loadDashboard(){

    let res = await fetch("http://127.0.0.1:8010/dashboard")
    
    let data = await res.json()
    
    document.getElementById("todaySales").innerText = "₹ " + data.today_sales
    document.getElementById("totalMeds").innerText = data.total_medicines
    document.getElementById("lowStock").innerText = data.low_stock.length
    document.getElementById("expiryAlert").innerText = data.expiring.length
    
    renderLowStock(data.low_stock)
    
    createChart(data.today_sales)
    
    }
    
    function renderLowStock(list){
    
    let html=""
    
    list.forEach(m=>{
    html+=`<div class="alertItem">${m}</div>`
    })
    
    document.getElementById("lowStockList").innerHTML = html
    
    }
    
    function createChart(total){
    
    const ctx = document.getElementById('salesChart')
    
    new Chart(ctx,{
    type:'bar',
    data:{
    labels:['Today'],
    datasets:[{
    label:'Sales',
    data:[total],
    backgroundColor:'#6366f1'
    }]
    }
    })
    
    }
    
    loadDashboard()