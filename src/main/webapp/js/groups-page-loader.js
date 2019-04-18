/*
 * Copyright 2019 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const urlParams = new URLSearchParams(window.location.search);
// const parameterUsername = urlParams.get('groups');

/** Fetches groups and adds them to the page. */
function fetchGroups() {
  let url = '/groups';
  fetch(url)
      .then((response) => {
        return response.json();
      })
      .then((groups) => {
        const groupsContainer = document.getElementById('groups-container');
        if (groups.length == 0) {
          groupsContainer.innerHTML = '<p>This user has no saved groups yet.</p>';
        } else {
          groupsContainer.innerHTML = '';
        }
        groups.forEach((group) => {
          const groupDiv = buildGroupDiv(group);
          groupsContainer.appendChild(groupDiv);
        })
      });
}

function buildGroupDiv(group) {
  const headerDiv = document.createElement('div');
  headerDiv.classList.add('group-header');
  headerDiv.appendChild(document.createTextNode(
      group.id +
      ' - ' +
      group.name +
      ' ['
      + group.course + ']'));

  const bodyDiv = document.createElement('div');
  bodyDiv.classList.add('group-body');
  bodyDiv.innerHTML = group.name;

  const groupDiv = document.createElement('div');
  groupDiv.classList.add('group-div');
  groupDiv.appendChild(headerDiv);
  groupDiv.appendChild(bodyDiv);

  return groupDiv;
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
