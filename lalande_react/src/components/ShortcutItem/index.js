
import React from 'react';
import './index.css';

function ShortcutItem({ title, imageUrl }) {
    return (
        <div className="shortcut-item">
            <img src={imageUrl} alt={title} />
            <p>{title}</p>
        </div>
    );
}

export default ShortcutItem;
