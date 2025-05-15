from flask import Flask, render_template
from chipotle_burrito_hunter_sdk import FoundryClient
from chipotle_burrito_hunter_sdk.ontology.objects import ChipotleLocation
from foundry_sdk_runtime.auth import UserTokenAuth
import folium
import os

app = Flask(__name__)

@app.route('/')
def index():
    # Authenticate and create a FoundryClient instance
    auth = UserTokenAuth(hostname=os.environ["FOUNDRY_URL"], token=os.environ["FOUNDRY_TOKEN"])
    client = FoundryClient(auth=auth, hostname=os.environ["FOUNDRY_URL"])

    # Query all Chipotle locations
    locations = list(client.ontology.objects.ChipotleLocation
                     .where(~ChipotleLocation.object_type.pkey.is_null())
                     .order_by(ChipotleLocation.object_type.pkey.asc())
                     .iterate())

    # Create a folium map centered at an average location (e.g., center of the US)
    m = folium.Map(location=[39.8283, -98.5795], zoom_start=4)

    # Add markers for each Chipotle location
    for loc in locations:
        folium.Marker(
            [loc.latitude, loc.longitude],
            popup=f"<b>{loc.city}</b>",
            tooltip="Click for more info"
        ).add_to(m)

    # Convert the map to HTML
    map_html = m._repr_html_()

    return render_template('index.html', map_html=map_html, locations=locations)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
