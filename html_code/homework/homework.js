let n = document.getElementById('money').innerHTML;
document.getElementById('money').innerHTML = parseFloat(n).toLocaleString();

function Refuse(){
    document.getElementById('invite').style.display = 'none';
    document.getElementById('wrapper').style.filter = 'brightness(100%)';
}

function Confirm(){
    let num = parseFloat(n);
    num+=100;
    n = num;
    if(document.getElementById('img1').style.filter === 'brightness(100%)'){
        document.getElementById('img2').style.filter = 'brightness(100%)';
        document.getElementById('add2').style.display = 'none';
        document.getElementById('chef6').style.background = 'linear-gradient(90deg,rgb(255,145,34) 50%,rgb(217,109,0) 50%)';
    }
    document.getElementById('money').innerHTML = num.toLocaleString();
    document.getElementById('invite').style.display = 'none';
    document.getElementById('wrapper').style.filter = 'brightness(100%)';
    document.getElementById('img1').style.filter = 'brightness(100%)';
    document.getElementById('add1').style.display = 'none';
    document.getElementById('chef5').style.background = 'linear-gradient(90deg,rgb(255,145,34) 50%,rgb(217,109,0) 50%)';
    document.getElementById('chef6').style.display = 'inline-flex';
}

function Add(){
    document.getElementById('invite').style.display = 'flex';
    document.getElementById('wrapper').style.filter = 'brightness(50%)';
}
