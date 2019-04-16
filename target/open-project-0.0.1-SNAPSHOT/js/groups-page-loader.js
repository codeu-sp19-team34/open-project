const urlParams = new URLSearchParams(window.location.search);
const parameterUsername = urlParams.get('groups');

/** Fetches groups and add them to the page. */
function fetchGroups() {
  const url = '/groups';
  fetch(url)
      .then((response) => {
        return response.json();
      })
      .then((groups) => {
        const groupsContainer = document.getElementById('groups-container');
        groupsContainer.innerHTML = '';

        const groupsCountElement = buildGroupElement('Groups: ' + groups.getGroups);
        statsContainer.appendChild(groupsCountElement);
      });
}

function buildStatElement(statString) {
  const statElement = document.createElement('p');
  statElement.appendChild(document.createTextNode(statString));
  return statElement;
}

/** Fetch data and populate the UI of the page. **/
function buildUI() {
  fetchGroups();
}
