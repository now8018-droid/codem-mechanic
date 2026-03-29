import lossantosModule from "./modules/lossantosModule.js";
import bossmenuModule from "./modules/bossmenuModule.js";
import jobmenuModule from "./modules/jobmenuModule.js";

let audioPlayer = null;
const Modules = {
    lossantosPage: lossantosModule,
    jobmenuPage: jobmenuModule,
    bossmenuPage: bossmenuModule
};

import lossantosPage from "../pages/lossantos/index.js";
import bossmenuPage from "../pages/bossmenu/index.js";
import jobmenuPage from "../pages/jobmenu/index.js";

String.prototype.format = function () {
    let formatted = this;
    for (let i = 0; i < arguments.length; i++) {
        let regexp = new RegExp("\\{" + i + "\\}", "gi");
        formatted = formatted.replace(regexp, arguments[i]);
    }
    return formatted;
};

const store = Vuex.createStore({
    components: {
        lossantosPage: lossantosPage,
        jobmenuPage: jobmenuPage,
        bossmenuPage: bossmenuPage
    },

    state: {
        activePage: "",
        profileAccount: false,
        notifications: [],
        timeout: false,
        locales: [],
        enableNPCMissions: true
    },
    getters: {},
    mutations: {
        setLocales(state, payload) {
            state.locales = payload;
        },
        setEnableNPCMissions(state, payload) {
            state.enableNPCMissions = payload;
        }
    },
    actions: {
        soundPlay({ state }, val) {
            clicksound(val);
        },
        notification({ state }, text) {
            const timeout = 4000;
            let id = Date.now();
            if (state.notifications.length > 0) {
                if (state.timeout) {
                    clearTimeout(state.timeout);
                    state.timeout = false;
                }
                state.notifications = [];
            }
            state.notifications.push({
                id: id,
                text: text,
                timeout: timeout
            });
            state.timeout = setTimeout(() => {
                state.notifications = state.notifications.filter(notification => notification.id != id);
            }, timeout);
        }
    },

    modules: Modules
});

const app = Vue.createApp({
    components: {
        lossantosPage: lossantosPage,
        jobmenuPage: jobmenuPage,
        bossmenuPage: bossmenuPage
    },
    data: () => ({
        otherSummuryBill: false,
        progressbar: 0,
        interval: null,
        progressbarLabel: ""
    }),
    computed: {
        ...Vuex.mapState({
            activePage: state => state.activePage,
            profileAccount: state => state.profileAccount,
            notifications: state => state.notifications,
            locales: state => state.locales
        })
    },

    watch: {},

    beforeDestroy() {
        window.removeEventListener("keyup", this.updateNavbarActive);
    },
    mounted() {
        document.querySelector('#app').style.display = 'block'
        window.addEventListener("keyup", this.keyHandler);
        window.addEventListener("message", this.eventHandler);
    },

    methods: {
        ...Vuex.mapMutations({
            setPlayerInventory: "bossmenuPage/setPlayerInventory",
            setBossInventory: "bossmenuPage/setBossInventory",
            setItemImagesFolder: "bossmenuPage/setItemImagesFolder",
            setEmployees: "bossmenuPage/setEmployees",
            setRanks: "bossmenuPage/setRanks",
            setMoney: "bossmenuPage/setMoney",
            setLogs: "bossmenuPage/setLogs",
            setLocales: "setLocales"
        }),
        startProgress(label, time) {
            this.progressbarLabel = label;
            this.progressbar = 0;
            clearInterval(this.interval);
            this.interval = setInterval(() => {
                this.progressbar += 100 / time;
                if (this.progressbar >= 100) {
                    clearInterval(this.interval);
                    setTimeout(() => {
                        this.progressbar = 0;
                        this.progressbarLabel = "";
                    }, 1000);
                }
            }, 1000);
        },
        keyHandler(e) {
            if (e.which == 27) {
                if (this.$store.state.activePage == "freecam") {
                    this.$store.state.activePage = "lossantosPage";
                    postNUI("openMouse", {});
                } else if (this.$store.state.activePage == "lossantosPage") {
                    if (this.$store.state.lossantosPage.vehicleBasket.length > 0) {
                        this.$store.state.activePage = "areusure";
                    } else {
                        postNUI("close", {});
                        this.$store.state.activePage = "";
                    }
                } else {
                    this.$store.state.activePage = "";
                    postNUI("close", {});
                }
            }
            if (e.which == 69) {
                postNUI("hornVehicle", {});
            }
        },
        closeOtherSummuryBill() {
            this.otherSummuryBill = false;
            postNUI("closeOtherSummuryBill");
        },
        closeMenu(val) {
            if (val) {
                this.$store.state.activePage = "";
                postNUI("close", {});
            } else {
                this.$store.state.activePage = "lossantosPage";
            }
        },
        eventHandler(event) {
            switch (event.data.action) {
                case "openmenu":
                    if (event.data.payload.menu == "mechanic") {
                        this.$store.state.activePage = "lossantosPage";
                        this.$store.state.profileAccount = event.data.payload.profileAccount;
                        this.$store.state.lossantosPage.mechanicVault = event.data.payload.vault;
                        this.$store.state.lossantosPage.mechanicLabel = event.data.payload.mechanicLabel;
                    } else if (event.data.payload.menu == "boss") {
                        this.$store.state.activePage = "bossmenuPage";
                        this.$store.state.profileAccount = event.data.payload.profileAccount;
                        this.$store.state.lossantosPage.mechanicLabel = event.data.payload.mechanicLabel;
                    } else if (event.data.payload.menu == "jobmenu") {
                        this.$store.state.activePage = "jobmenuPage";
                    }
                    break;
                case "showProgressBar":
                    this.startProgress(event.data.payload.label, event.data.payload.time);
                    break;
                case "UPDATE_LOGS":
                    this.setLogs(event.data.payload);
                    break;
                case "configCategoryLocked":
                    this.$store.state.lossantosPage.categoryLocked = event.data.payload;
                    break;
                case "RefreshMechanicVault":
                    this.$store.state.lossantosPage.mechanicVault = event.data.payload;
                    break;
                case "configDefaulPrice":
                    this.$store.state.lossantosPage.configMechanicPrice = event.data.payload;
                    break;
                case "openFreeCam":
                    this.$store.state.activePage = "freecam";
                    break;
                case "configMechanicSettings":
                    this.$store.state.lossantosPage.mechanicCategories = event.data.payload;
                    break;
                case "showBill":
                    this.otherSummuryBill = event.data.payload;
                    break;
                case "configMechanicThema":
                    this.$store.state.lossantosPage.currentThema = event.data.payload;
                    break;
                case "CHECK_NUI":
                    postNUI("loaded");
                    break;
                case "SET_NOTIFICATION":
                    this.$store.dispatch("notification", event.data.payload);
                    break;
                case "SetInventory":
                    this.setPlayerInventory(event.data.payload);
                    break;
                case "UPDATE_BOSS_INVENTORY":
                    this.setBossInventory(event.data.payload);
                    break;
                case "SET_ITEM_IMAGES_FOLDER":
                    this.setItemImagesFolder(event.data.payload);

                    break;
                case "SET_EMPLOYEES":
                    this.setEmployees(event.data.payload);

                    break;
                case "SET_RANKS":
                    this.setRanks(event.data.payload);
                    break;
                case "SET_BOSS_MONEY":
                    this.setMoney(event.data.payload);
                    break;
                case "SET_LOCALES":
                    this.setLocales(event.data.payload);
                    break;
                case "configEnableNPCMissions":
                    this.$store.commit('setEnableNPCMissions', event.data.payload);
                    break;
                default:
                    break;
            }
        }
    }
});

app.use(store).mount("#app");
var resourceName = "codem-mechanic";

if (window.GetParentResourceName) {
    resourceName = window.GetParentResourceName();
}

window.postNUI = async (name, data) => {
    try {
        const response = await fetch(`https://${resourceName}/${name}`, {
            method: "POST",
            mode: "cors",
            cache: "no-cache",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            redirect: "follow",
            referrerPolicy: "no-referrer",
            body: JSON.stringify(data)
        });
        return !response.ok ? null : response.json();
    } catch (error) {
        // console.log(error)
    }
};

function clicksound(val) {
    let audioPath = "./sound/" + val + ".ogg";
    audioPlayer = new Howl({
        src: [audioPath]
    });
    audioPlayer.volume(0.4);
    audioPlayer.play();
}
