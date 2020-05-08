let img;
let table;
let h = 800;
let w = 600;

function preload() {
  img = loadImage('assets/city.png');
  table = loadTable('assets/city_data.csv', 'csv', 'header');
}

// global setup function
function setup() {
  createCanvas(w, h);
  background(255);
  
  // global typography setup
  textAlign(RIGHT);
  textStyle(BOLD);
  textFont('Arial Black');
  fill(8, 69, 150);
  
  // city typography
  let city = table.getColumn('city');
  textSize(22);
  text(city, w - 40, h - 60);
  
  // year typography
  let year = table.getColumn('year');
  textSize(16);
  text(year, w - 40, h - 40);
  
  // coordinates typography
  textSize(8);
  let coor = 
      table.getColumn('y_avg') + 
      '° N / ' +
      table.getColumn('x_avg') +
      '° E';
  text(coor, w - 40, h - 20);
  
}

// global draw function
function draw() {
  image(img, 50, 50, 500, 650);
}
