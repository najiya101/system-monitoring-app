## System monitoring app
System Monitor is a Flutter-based app designed to track real-time CPU, memory, and disk usage. It features intuitive radial bar charts and line graphs to visualize system performance metrics, with data from json file updating every 5 seconds .

## Features
- Real Time Monitoring
- Visual Representation
- Dynamic Line Charts
- Navigation Buttons
- Settings Menu

## For User
### Installation
* 1, Clone the repository or download the latest release of the app
* 2, If the repository is cloned then install dependencies
* 3, Run the app
* 4, Click on the settings icon
* 5, Enter the source url in the settings
* 6, Restart the app

### Usage
* Home Page: This is the central hub, displaying real-time CPU, memory, and disk usage with dynamic radial bar charts and providing navigation to detailed monitoring pages for each resource.
* Connect Pages: It handles loading a URL from a file or default asset, and fetching system metrics from that URL, returning the data as a JSON-decoded map.
* Settings: Access the settings page via the three-dot menu to update the data fetching URL.

### Configuration
* The app fetches system metrics from an external API. The URL for the API is stored in a text file within the app, making it easy to update without modifying the code. The default URL can be changed through the settings page.

## For Developer
* system monitor real time data in json file format

```json
{
  "cpu_usage_percentage": -> CPU utilization percentage
  "memory_usage": { 
    "total_mb": -> Total RAM capacity
    "used_mb": -> Currently used RAM
    "free_mb": -> Free RAM available
  },
  "disk_usage": {
    "total_mb": -> Total capacity of HDD storage
    "used_mb": -> Currently used storage
    "free_mb": -> Free available storage
  }
}
```

Example API Response:

```json
{
  "cpu_usage_percentage": 25.6,
  "memory_usage": {
    "total_mb": 1963,
    "used_mb": 1153,
    "free_mb": 88
  },
  "disk_usage": {
    "total_mb": 39511,
    "used_mb": 21401,
    "free_mb": 18110
  }
}
```
* Replace "your url" text to paste the url to load make sure it in json format which cannot change by the user directly through the code

## Screenshots

<div>
   
</div>