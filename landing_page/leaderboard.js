// Leaderboard functionality

// Sample data for different sorting options
const leaderboardData = {
    earnings: [
        { rank: 1, name: "Priya Sharma", avatar: "👩‍💻", earnings: 58900, orders: 187, weight: 1024, badge: "Gold VIP" },
        { rank: 2, name: "Rajesh Kumar", avatar: "👨‍💼", earnings: 42500, orders: 165, weight: 893, badge: "Silver VIP" },
        { rank: 3, name: "Amit Singh", avatar: "👨‍🔬", earnings: 38200, orders: 148, weight: 821, badge: "Silver VIP" },
        { rank: 4, name: "Vikram Patel", avatar: "👨‍🎨", earnings: 32400, orders: 152, weight: 845, badge: "VIP" },
        { rank: 5, name: "Neha Gupta", avatar: "👩‍🏫", earnings: 28700, orders: 138, weight: 782, badge: "VIP" },
        { rank: 6, name: "Arjun Mehta", avatar: "👨‍💼", earnings: 25100, orders: 125, weight: 698, badge: "Member" },
        { rank: 7, name: "Kavya Reddy", avatar: "👩‍⚕️", earnings: 23800, orders: 118, weight: 654, badge: "Member" },
        { rank: 8, name: "Sanjay Verma", avatar: "👨‍🍳", earnings: 21400, orders: 105, weight: 589, badge: "Member" },
        { rank: 9, name: "Anjali Nair", avatar: "👩‍🔬", earnings: 19600, orders: 98, weight: 542, badge: "Member" },
        { rank: 10, name: "Rohan Kapoor", avatar: "👨‍🚀", earnings: 18200, orders: 92, weight: 512, badge: "Member" }
    ],
    orders: [
        { rank: 1, name: "Priya Sharma", avatar: "👩‍💻", earnings: 58900, orders: 187, weight: 1024, badge: "Gold VIP" },
        { rank: 2, name: "Rajesh Kumar", avatar: "👨‍💼", earnings: 42500, orders: 165, weight: 893, badge: "Silver VIP" },
        { rank: 3, name: "Vikram Patel", avatar: "👨‍🎨", earnings: 32400, orders: 152, weight: 845, badge: "VIP" },
        { rank: 4, name: "Amit Singh", avatar: "👨‍🔬", earnings: 38200, orders: 148, weight: 821, badge: "Silver VIP" },
        { rank: 5, name: "Neha Gupta", avatar: "👩‍🏫", earnings: 28700, orders: 138, weight: 782, badge: "VIP" },
        { rank: 6, name: "Arjun Mehta", avatar: "👨‍💼", earnings: 25100, orders: 125, weight: 698, badge: "Member" },
        { rank: 7, name: "Kavya Reddy", avatar: "👩‍⚕️", earnings: 23800, orders: 118, weight: 654, badge: "Member" },
        { rank: 8, name: "Sanjay Verma", avatar: "👨‍🍳", earnings: 21400, orders: 105, weight: 589, badge: "Member" },
        { rank: 9, name: "Anjali Nair", avatar: "👩‍🔬", earnings: 19600, orders: 98, weight: 542, badge: "Member" },
        { rank: 10, name: "Rohan Kapoor", avatar: "👨‍🚀", earnings: 18200, orders: 92, weight: 512, badge: "Member" }
    ],
    impact: [
        { rank: 1, name: "Priya Sharma", avatar: "👩‍💻", earnings: 58900, orders: 187, weight: 1024, badge: "Gold VIP" },
        { rank: 2, name: "Rajesh Kumar", avatar: "👨‍💼", earnings: 42500, orders: 165, weight: 893, badge: "Silver VIP" },
        { rank: 3, name: "Vikram Patel", avatar: "👨‍🎨", earnings: 32400, orders: 152, weight: 845, badge: "VIP" },
        { rank: 4, name: "Amit Singh", avatar: "👨‍🔬", earnings: 38200, orders: 148, weight: 821, badge: "Silver VIP" },
        { rank: 5, name: "Neha Gupta", avatar: "👩‍🏫", earnings: 28700, orders: 138, weight: 782, badge: "VIP" },
        { rank: 6, name: "Arjun Mehta", avatar: "👨‍💼", earnings: 25100, orders: 125, weight: 698, badge: "Member" },
        { rank: 7, name: "Kavya Reddy", avatar: "👩‍⚕️", earnings: 23800, orders: 118, weight: 654, badge: "Member" },
        { rank: 8, name: "Sanjay Verma", avatar: "👨‍🍳", earnings: 21400, orders: 105, weight: 589, badge: "Member" },
        { rank: 9, name: "Anjali Nair", avatar: "👩‍🔬", earnings: 19600, orders: 98, weight: 542, badge: "Member" },
        { rank: 10, name: "Rohan Kapoor", avatar: "👨‍🚀", earnings: 18200, orders: 92, weight: 512, badge: "Member" }
    ]
};

let currentSort = 'earnings';

// Sort leaderboard
function sortLeaderboard(type) {
    currentSort = type;
    
    // Update button states
    const buttons = document.querySelectorAll('.sort-btn');
    buttons.forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
    
    // Update podium
    updatePodium(type);
    
    // Update list
    updateList(type);
}

// Update podium (top 3)
function updatePodium(type) {
    const data = leaderboardData[type];
    
    // Get podium elements
    const podiumItems = document.querySelectorAll('.podium-item');
    
    // Update 2nd place (first element)
    updatePodiumItem(podiumItems[0], data[1], '2nd', 'silver');
    
    // Update 1st place (second element)
    updatePodiumItem(podiumItems[1], data[0], '1st', 'gold');
    
    // Update 3rd place (third element)
    updatePodiumItem(podiumItems[2], data[2], '3rd', 'bronze');
}

// Update individual podium item
function updatePodiumItem(element, user, rank, medal) {
    const avatar = element.querySelector('.podium-avatar');
    const rankEl = element.querySelector('.podium-rank');
    const name = element.querySelector('h3');
    const statValue = element.querySelector('.stat-value');
    const statLabel = element.querySelector('.stat-label');
    const badge = element.querySelector('.badge');
    
    avatar.textContent = user.avatar;
    name.textContent = user.name;
    
    if (currentSort === 'earnings') {
        statValue.textContent = `₹${user.earnings.toLocaleString()}`;
        statLabel.textContent = 'Total Earned';
    } else if (currentSort === 'orders') {
        statValue.textContent = user.orders;
        statLabel.textContent = 'Total Orders';
    } else {
        statValue.textContent = `${user.weight} kg`;
        statLabel.textContent = 'Recycled';
    }
    
    badge.textContent = getBadgeIcon(user.badge) + ' ' + user.badge;
}

// Update leaderboard list (4-10)
function updateList(type) {
    const data = leaderboardData[type].slice(3); // Get items 4-10
    const listContainer = document.querySelector('.leaderboard-list');
    
    listContainer.innerHTML = '';
    
    data.forEach(user => {
        const item = createLeaderboardItem(user);
        listContainer.appendChild(item);
    });
}

// Create leaderboard item element
function createLeaderboardItem(user) {
    const item = document.createElement('div');
    item.className = 'leaderboard-item';
    
    let primaryStat;
    if (currentSort === 'earnings') {
        primaryStat = `₹${user.earnings.toLocaleString()}`;
    } else if (currentSort === 'orders') {
        primaryStat = `${user.orders} orders`;
    } else {
        primaryStat = `${user.weight} kg`;
    }
    
    const badgeClass = user.badge.includes('VIP') ? 'vip' : '';
    
    item.innerHTML = `
        <div class="rank">${user.rank}</div>
        <div class="user-info">
            <div class="user-avatar">${user.avatar}</div>
            <div class="user-details">
                <h4>${user.name}</h4>
                <p>${user.orders} orders • ${user.weight} kg recycled</p>
            </div>
        </div>
        <div class="user-stats">
            <div class="stat-primary">${primaryStat}</div>
            <div class="badge-small ${badgeClass}">${user.badge}</div>
        </div>
    `;
    
    return item;
}

// Get badge icon
function getBadgeIcon(badge) {
    if (badge.includes('Gold')) return '🥇';
    if (badge.includes('Silver')) return '🥈';
    if (badge === 'VIP') return '💎';
    return '⭐';
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    console.log('Leaderboard loaded');
});
