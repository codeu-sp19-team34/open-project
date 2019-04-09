// JavaScript functions for loading the map page

function createMap() {
  const map = new google.maps.Map(document.getElementById('map'), {
    center: { lat: 37.422403, lng: -122.088073 },
    zoom: 15
  });

  addLandmark(map, 37.423829, -122.092154, 'Google West Campus', 'Home to YouTube and Maps.');
  addLandmark(map, 37.421903, -122.084674, 'Stan the T-Rex', 'Here lies Stan, the T-Rex statue.');
  addLandmark(map, 37.420919, -122.086619, 'Permanente Creek Trail', 'Permanente Creek Trail connects Google to a system of bike trails.');
}

function addLandmark(map, lat, lng, title, description) {
  const marker = new google.maps.Marker({
    position: { lat: lat, lng: lng },
    map: map,
    title: title
  });

  var infoWindow = new google.maps.InfoWindow({
    content: description
  });

  marker.addListener('click', function() {
    infoWindow.open(map, marker);
  });
}
