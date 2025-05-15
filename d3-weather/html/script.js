const timeOptions = 24;
let currentTime = 12;

const weatherOptions = [
    "CLEAR",
    "EXTRASUNNY",
    "CLOUDS",
    "OVERCAST",
    "RAIN",
    "THUNDER",
    "SMOG",
    "FOGGY",
    "XMAS",
    "SNOWLIGHT",
    "BLIZZARD",
    "SNOW",
    "HALLOWEEN",
    "CLEARING",
    "NEUTRAL"
];

let currentWeatherIndex = 7; 

const container = document.getElementById('container');
const timeDisplay = document.getElementById('time-display');
const timeCount = document.getElementById('time-count');
const weatherDisplay = document.getElementById('weather-display');
const weatherCount = document.getElementById('weather-count');

const timeLeftBtn = document.getElementById('time-left');
const timeRightBtn = document.getElementById('time-right');
const weatherLeftBtn = document.getElementById('weather-left');
const weatherRightBtn = document.getElementById('weather-right');

function updateTimeDisplay() {
    timeDisplay.textContent = currentTime;
    timeCount.textContent = `< ${currentTime + 1}/${timeOptions} >`;
    fetch(`https://${GetParentResourceName()}/setTime`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ hour: currentTime })
    });
}

function updateWeatherDisplay() {
    weatherDisplay.textContent = weatherOptions[currentWeatherIndex];
    weatherCount.textContent = `< ${currentWeatherIndex + 1}/${weatherOptions.length} >`;
    fetch(`https://${GetParentResourceName()}/setWeather`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ weather: weatherOptions[currentWeatherIndex] })
    });
}

timeLeftBtn.onclick = () => {
    currentTime = (currentTime - 1 + timeOptions) % timeOptions;
    updateTimeDisplay();
};

timeRightBtn.onclick = () => {
    currentTime = (currentTime + 1) % timeOptions;
    updateTimeDisplay();
};

weatherLeftBtn.onclick = () => {
    currentWeatherIndex = (currentWeatherIndex - 1 + weatherOptions.length) % weatherOptions.length;
    updateWeatherDisplay();
};

weatherRightBtn.onclick = () => {
    currentWeatherIndex = (currentWeatherIndex + 1) % weatherOptions.length;
    updateWeatherDisplay();
};

window.addEventListener('message', (event) => {
    if (event.data.action === "show") {
        container.classList.remove('hidden');
        updateTimeDisplay();
        updateWeatherDisplay();
    } else if (event.data.action === "hide") {
        container.classList.add('hidden');
    }
});

document.addEventListener('keydown', (e) => {
    if (e.key === "Escape") {
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    }
});
