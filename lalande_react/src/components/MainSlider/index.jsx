import React, { useState, useEffect } from 'react';
import './index.css';

function MainSlider({ banners }) {

    const [currentSlide, setCurrentSlide] = useState(0);
    const slideInterval = 5000;

    useEffect(() => {
        const interval = setInterval(() => {
            setCurrentSlide((current) => (current === banners.length - 1 ? 0 : current + 1));
        }, slideInterval);
        return () => clearInterval(interval);
    }, [currentSlide, banners.length]);

    if (!banners || banners.length === 0) {
        return <div className="slider-container loader"></div>;
    }

    const slideCount = banners.length;

    return (
        <div className="slider-container">
            {banners.map((banner, index) => {
                let slideClass = '';
                let position = index - currentSlide;
                if (position === 0) {
                    slideClass = 'active';
                } else if (position === -1) {
                    slideClass = 'active-1';
                } else if (position === 1) {
                    slideClass = 'active-2';
                } else if (position === -2 && currentSlide === 0) {
                    slideClass = 'active-1';
                } else if (position === 2 && currentSlide === slideCount - 1) {
                    slideClass = 'active-2';
                } else if (index === 0 && currentSlide === slideCount - 1) {
                    slideClass = 'active-2';
                } else if (index === slideCount - 1 && currentSlide === 0) {
                    slideClass = 'active-1';
                }

                return (
                    <div className={`slide ${slideClass}`} key={banner.mainBannerId}>
                        <img src={banner.pcImageUrl} alt={banner.title}/>
                    </div>
                );
            })}
            <button className="prev"
                    onClick={() => setCurrentSlide(currentSlide === 0 ? banners.length - 1 : currentSlide - 1)}>&#10094;</button>
            <button className="next"
                    onClick={() => setCurrentSlide(currentSlide === banners.length - 1 ? 0 : currentSlide + 1)}>&#10095;</button>

            <div className="slider-indicators">
                {banners.map((_, index) => (
                    <div
                        key={index}
                        className={`indicator ${index === currentSlide ? 'active' : ''}`}
                        onClick={() => setCurrentSlide(index)}
                    ></div>
                ))}
            </div>

        </div>
    );
}

export default MainSlider;
