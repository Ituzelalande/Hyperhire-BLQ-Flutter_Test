import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './index.css';

const DealsSwiper = () => {
    const [items, setItems] = useState([]);

    useEffect(() => {
        const fetchItems = async () => {
            try {
                const response = await axios.get('https://api.testvalley.kr/collections?prearrangedDiscount');
                setItems(response.data.items);
            } catch (error) {
                console.error('Error fetching items:', error);
            }
        };

        fetchItems();
    }, []);

    const sectionsData = [
        {
            id: 0,
            title: '벤하임 신규입점 EVENT',
            subtitle: '최저가 보장, 5% 다운로드 쿠폰',
        },
        {
            id: 1,
            title: 'New In',
            subtitle: '#주목할만한신상품',
        },
        {
            id: 2,
            title: 'Weekly Hot Deal',
            subtitle: '#최대할인상품',
        },
        {
            id: 3,
            title: '로지텍 AS보장 정품 마우스/키보드 단독',
            subtitle: '#병행수입 아닌 정품 제품으로 확실한 AS보장!',
        },
        {
            id: 4,
            title: '더욱 얇고 강력해진 LG그램 프로 16인치',
            subtitle: '추가 할인 쿠폰 + 30일 체험비 인하 이벤트',
        },
        {
            id: 5,
            title: '게임기기 최저가 & 신작 모음',
            subtitle: '#한정수량 특가 #기대신작',
        },
        {
            id: 6,
            title: '전기 매트 LAST BIG SALE',
            subtitle: 'UP TO 64% SALE',
        },
        {
            id: 7,
            title: '설날선물 추천템, 테팔 후라이팬 &쿠커 특',
            subtitle: 'UP TO 74%',
        },
        {
            id: 8,
            title: '맥북 클리어런스 세일!',
            subtitle: '오직 테스트밸리에서만! 30일 체험해보고 구매하자',
        },
    ];

    const slides = [];
    let n = 0;
    for (let i = 0; i < items.length; i += 4) {

        const item = items[i];
        const image = item.thumbnail ? item.thumbnail.uri : '';

        if(image) {
            const index = n % 4;
            if(!slides[index]) slides[index] = [];
            slides[index].push(
                <div className="swiper-slide slideWrapper">
                    <div className="dael-card">
                        <div className="dael-card-container">
                            <div type="m" className="dael-card-top">
                                <div className="dael-card-image-box">
                                    <div type="m" className="dael-card-image-holder">
                                        <img src="/assets/images/return-new.svg" alt=""/>
                                        {item.returnPolicy ? '리턴 가능' : ''}
                                    </div>
                                </div>
                                <div type="m" className="dael-card-image-title"></div>
                            </div>
                            <div className="dael-card-image-thumbnail">
                                <img src={item.thumbnail ? item.thumbnail.uri : ''} alt={item.title}
                                     className="dael-card-thumbnail"/>
                            </div>
                        </div>
                        <div className="dael-card-title">{item.description || item.title}</div>
                        <div className="dael-card-amount">
                            <span>{item.discountPercentage || '5'}%</span>{item.price || '28,405'}
                        </div>
                        <div className="dael-card-footer">
                            <div className="dael-card-footer-divider"></div>
                            <div className="dael-card-footer-holder">
                                <div className="dael-card-footer-rating">
                                    <img src="/assets/images/star-darkgray.svg" alt="별점" width="12px" height="12px"/>
                                    {item.rating || '5'}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>)
            n++;
        }
    }

    const renderSlides = (position) => {
        return slides.length > position ? slides[position] : [];
    };

    if (!slides || slides.length === 0) {
        return <div className="slider-container loader"></div>;
    }

    return (
        <div className="container">
            {sectionsData.map((section, index) => (
                <div key={index} className="daels-container">
                    <div className="daels-content">
                        <div className="daels-content-title">{section.title}</div>
                        <div className="daels-content-subtitle">{section.subtitle}</div>
                    </div>
                    <div className="swiper-container swiper-container-initialized swiper-container-horizontal swiper-container-pointer-events swiper">
                        <div className="swiper-button-prev swiper-button-disabled">
                            &#10094;
                        </div>
                        <div className="swiper-button-next swiper-button-disabled">
                            &#10095;
                        </div>
                        <div className="swiper-wrapper">
                            {renderSlides(section.id)}
                        </div>
                    </div>
                </div>
            ))}
        </div>
    );
};

export default DealsSwiper;
