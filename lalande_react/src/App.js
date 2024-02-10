import React, { useState, useEffect } from 'react';
import Navbar from './components/Navbar';
import MainSlider from './components/MainSlider';
import ShortcutItem from "./components/ShortcutItem";
import DealsSwiper from "./components/DealsSwiper";

function App() {

    const [banners, setBanners] = useState([]);
    const [shortcutItems, setShortcutItems] = useState([]);

    useEffect(() => {
        fetch('https://api.testvalley.kr/main-banner/all')
            .then((response) => response.json())
            .then((data) => {
                setBanners(data);
            })
            .catch((error) => {
                console.error('Error fetching data: ', error);
            });
    }, []);

    useEffect(() => {
        fetch('https://api.testvalley.kr/main-shortcut/all')
            .then((response) => response.json())
            .then((data) => {
                setShortcutItems(data);
            })
            .catch(error => {
                console.error('Error fetching shortcut items:', error);
            });
    }, []);


    return (
        <div>
            <Navbar />

            <MainSlider banners={banners} />

            <div className="shortcut-container">
                {shortcutItems.map(item => (
                    <ShortcutItem
                        key={item.mainShortcutId}
                        title={item.title}
                        imageUrl={item.imageUrl}
                    />
                ))}
            </div>

            <DealsSwiper />

        </div>
    );
}

export default App;
