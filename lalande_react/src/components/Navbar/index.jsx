import React, { useState, useEffect, useRef } from 'react';
import './index.css';
import Categories from "../Categories";

function Navbar() {
    const [showCategories, setShowCategories] = useState(false);
    const categoryTextRef = useRef(null);
    const categoriesRef = useRef(null);

    const toggleCategories = () => {
        setShowCategories(!showCategories);
    };

    const handleClickOutside = (event) => {
        if (categoriesRef.current && !categoriesRef.current.contains(event.target) &&
            !categoryTextRef.current.contains(event.target)) {
            setShowCategories(false);
        }
    };

    useEffect(() => {
        document.addEventListener("mousedown", handleClickOutside);

        return () => {
            document.removeEventListener("mousedown", handleClickOutside);
        };
    }, []);

    return (
        <div>
            <header className="header-main">
                <div className="header-container">
                    <div className="logo-search-wrap">
                        <img src="/assets/images/logo-new.svg" alt="testvalley" className="logo-img"/>
                        <div ref={categoryTextRef} className="category-text" onClick={toggleCategories}>
                            카테고리
                        </div>
                        <div className="search-box">
                            <img src="/assets/images/search.svg" alt="" className="search-icon"/>
                            <input type="search" placeholder="살까말까 고민된다면 검색해보세요!" className="search-input"/>
                        </div>
                    </div>
                    <div className="login-signup-wrap">
                        <button>
                            <img src="/assets/images/home-event.svg" alt=""/>
                        </button>
                        <img className="divider-bar" src="/assets/images/vertical-bar.svg" alt=""/>
                        <button>로그인 / 회원가입</button>
                    </div>
                </div>
            </header>

            {showCategories && <div ref={categoriesRef}><Categories /></div>}
        </div>
    );
}

export default Navbar;
