import importTemplate from "../../js/util/importTemplate.js";
import stanceComponentsMenu from "./components/stancemenu/index.js";
import vehicleComponentsCard from "./components/vehiclecard/index.js";
import vehicleColorMenu from "./components/colormenu/index.js";
export default {
    template: await importTemplate("pages/lossantos/index.html"),

    components: {
        stanceComponentsMenu,
        vehicleComponentsCard,
        vehicleColorMenu
    },
    data: () => ({
        currentCategory: false,
        summaryModal: false,
        billModal: false,
        currentPage: 1,
        selectedColor: "",
        selectTextHeader: "",
        currentThema: "blue",
        openPage: false,
        cameraSettings: false,
        mechanicCategoryItemName: false,
        hoveredIndex: null,
        currentCategoryTable: [],
        mechanicSwiperValue: false,

        sliderValue: 0.5,
        colorSwiper: false,
        selectedColorIndex: 0,
        showBillPlayer: true,
        nearbyPlayers: false,
        deleteVehicleBasketData: false
    }),
    methods: {
        billPlayer(plyid) {
            if (this.totalPriceVehicleBasket <= 1) return this.$store.dispatch("notification", this.locales.NO_INVOICE);
            postNUI("billPlayer", { plyid: plyid, totalPrice: this.totalPriceVehicleBasket });
            this.$store.dispatch("notification", this.locales.INVOICE_SENT);
        },

        showNearbyPlayerBill(plyid) {
            if (this.totalPriceVehicleBasket <= 1) return this.$store.dispatch("notification", this.locales.NO_INVOICE_TO_SHOW);
            postNUI("showNearbyPlayerBill", {
                plyid: plyid,
                totalPrice: this.totalPriceVehicleBasket,
                basketList: this.$store.state.lossantosPage.vehicleBasket
            });
        },

        paynowButton() {
            if (this.totalPriceVehicleBasket > 1) {
                if (parseInt(this.$store.state.lossantosPage.mechanicVault) >= parseInt(this.totalPriceVehicleBasket)) {
                    postNUI("vehicleMechanicComplete", this.totalPriceVehicleBasket);
                    this.$store.dispatch("notification", this.locales.PAYMENT_COMPLETED);
                } else {
                    return this.$store.dispatch("notification", this.locales.NOT_ENOUGH_MONEY);
                }
            } else {
                return this.$store.dispatch("notification", this.locales.NO_INVOICE);
            }
        },

        deleteVehicleBasket(data) {
            this.deleteVehicleBasketData = data;
        },
        deleteItemBasket(value) {
            if (value) {
                this.$store.dispatch("soundPlay", "install");
                postNUI("deleteVehicleBasket", value);
                this.deleteVehicleBasketData = false;
            } else {
                this.deleteVehicleBasketData = false;
            }
        },

        findVehiclePrice(index, isFixed) {
            if (this.mechanicCategoryItemName) {
                if (!isFixed) {
                    let price = parseInt(this.mechanicCategoryItemName.price);
                    let classPrice = 1;

                    let priceMultiplier = 1;

                    let finalPrice = price * classPrice * priceMultiplier;

                    return finalPrice.toFixed(0);
                } else {
                    let price = parseInt(this.mechanicCategoryItemName.price);
                    let classPrice = parseInt(this.mechanicCategoryItemName.classPrice);

                    let priceMultiplier = 1 + index * 0.1;

                    let finalPrice = price * classPrice * priceMultiplier;

                    return finalPrice.toFixed(0);
                }
            }
            return 0;
        },
        OnChangeColor(e) {
            let rgbValue = hexToRgb(e.target.value);
            let dataType = e.target.getAttribute("data-type");
            if (dataType == "primarycolor") {
                this.$store.dispatch("soundPlay", "spray");
                postNUI("setVehicleColor", { modname: "primarycolor", color: rgbValue });
            }
            if (dataType == "pearlescentcolor") {
                this.$store.dispatch("soundPlay", "spray");
                postNUI("setVehicleColor", { modname: "pearlescentcolor", color: rgbValue });
            }
            if (dataType == "secondarycolor") {
                this.$store.dispatch("soundPlay", "spray");
                postNUI("setVehicleColor", { modname: "secondarycolor", color: rgbValue });
            }
            if (dataType == "extracolor") {
                this.$store.dispatch("soundPlay", "spray");
                postNUI("setVehicleColor", { modname: "extracolor", color: rgbValue });
            }
            if (dataType == "allsidesneon") {
                this.$store.dispatch("soundPlay", "spray");
                postNUI("setVehicleColor", { modname: "allsidesneon", color: rgbValue });
            }
            if (dataType == "tiresmoke") {
                this.$store.dispatch("soundPlay", "spray");
                postNUI("setVehicleColor", { modname: "tiresmoke", color: rgbValue });
            }
        },
        mouseOver(index) {
            this.hoveredIndex = index;
        },
        mouseLeave() {
            this.hoveredIndex = null;
        },

        initSwiper() {
            if (this.mechanicSwiperValue) {
                this.mechanicSwiperValue.destroy();
            }
            this.mechanicSwiperValue = new Swiper("#bottomcategory", {
                slidesPerView: 4,
                spaceBetween: 30,
                slidesPerGroup: 4,
                loop: false,

                pagination: {
                    el: ".swiper-pagination",
                    clickable: true
                },
                navigation: {
                    nextEl: "#test1",
                    prevEl: "#test"
                }
            });
        },

        selectMechanicCategoryItem(val) {
            if (this.mechanicCategoryItemName.name == val.name) return;
            if (val.locked) return;
            this.refreshButton(val.modId);
            for (let key in this.currentCategoryTable) {
                if (key != val.name) {
                    this.currentCategoryTable[key] = false;
                }
            }
            this.currentCategoryTable[val.name] = !this.currentCategoryTable[val.name];
        },
        openBillModal(val) {
            if (val) {
                postNUI("checkNearbyPlayers");
            }
            this.billModal = val;
        },
        openSummaryModal(val) {
            this.summaryModal = val;
        },
        changeCategory(category, label) {
            if (this.$store.state.lossantosPage.categoryLocked[category]) return;

            this.$store.state.lossantosPage.stanceMenu = false;
            this.$store.state.lossantosPage.openColorMenu = false;
            this.$store.state.lossantosPage.wheelColor = false;
            this.$store.state.lossantosPage.vehicleCard = true;
            if (category !== 996) {
                postNUI("openVehicleNeon", false);
            }
            if (category == "freecam" || category == "freecam2") {
                return postNUI("freecam");
            }

            if (category == "repair") {
                this.$store.dispatch("soundPlay", "install");
                return postNUI("repairVehicle");
            }
            if (category == "clean") {
                return postNUI("cleanVehicle");
            }

            this.selectTextHeader = label;
            if (category == "liveries") {
                this.refreshButton(48);
            }
            if (category == "horns") {
                this.refreshButton(14);
            }
            if (category == "neons") {
                this.refreshButton(996);
            }
            if (category == "paint") {
                this.refreshButton(992);
            }
            if (category == "wheel") {
                this.refreshButton(991);
            }
            if (category == "extra") {
                this.refreshButton(1000);
            }

            if (category == "stance") {
                if (!this.$store.state.lossantosPage.stanceMenu) {
                    this.$store.state.lossantosPage.stanceMenu = true;
                } else {
                    this.$store.state.lossantosPage.stanceMenu = false;
                    this.$store.state.lossantosPage.vehicleCard = true;
                    this.$store.state.lossantosPage.openColorMenu = false;
                }
            }

            if (this.$store.state.lossantosPage.mechanicCategories[category]) {
                this.currentCategory = this.$store.state.lossantosPage.mechanicCategories[category];

                this.mechanicCategoryItemName = false;
                for (let key in this.currentCategoryTable) {
                    this.currentCategoryTable[key] = false;
                }
            }
        },
        backToCategory() {
            this.currentCategory = false;
            this.mechanicCategoryItemName = false;
            for (let key in this.currentCategoryTable) {
                this.currentCategoryTable[key] = false;
            }
            postNUI("cancelCamera");
        },

        refreshButton(val) {
            if (this.mechanicCategoryItemName.modId == val) return;
            const swiperInitKeys = [996, 991, 997, 991, "wheeltype", 992, 994, 993, 18];
            const wheelTypes = ["sport", "muscle", "lowrider", "stock", "suv", "offroad", "tuner", "bike", "highend"];
            if (!this.mechanicCategoryItemName) {
                if (swiperInitKeys.includes(val)) {
                    this.mechanicCategoryItemName = this.$store.state.lossantosPage.configMechanicPrice[val];

                    if (val == 997 || val == 994 || val == 993 || val == 18 || val == 991) {
                        postNUI("changeVehicleCamera", val);
                        if (val == 18) {
                            postNUI("turboOpen");
                        }
                        if (val == 997) {
                            postNUI("xenonOpen");
                        }
                    }
                    if (val == 996) {
                        postNUI("openVehicleNeon", true);

                        setTimeout(() => {
                            for (let key in this.mechanicCategoryItemName.count) {
                                if (key == 0) {
                                    this.mechanicCategoryItemName.count[key].price = 0;
                                } else {
                                    this.mechanicCategoryItemName.count[key].price = this.$store.state.lossantosPage.configMechanicPrice[996].price;
                                }
                            }
                        }, 10);
                    }

                    setTimeout(() => {
                        this.initSwiper();
                    }, 20);
                    return;
                }

                if (wheelTypes.includes(val)) {
                    postNUI("selectVehicleWheel", { name: val });
                    return;
                }
                if (val == 1000) {
                    postNUI("getVehicleExtra");
                    return;
                }

                postNUI("selectMechanicCategoryItem", val);
            } else {
                this.mechanicCategoryItemName = false;
                setTimeout(() => {
                    if (swiperInitKeys.includes(val)) {
                        if (val == 997 || val == 994 || val == 993 || val == 18 || val == 991) {
                            postNUI("changeVehicleCamera", val);
                            if (val == 18) {
                                postNUI("turboOpen");
                            }
                            if (val == 997) {
                                postNUI("xenonOpen");
                            }
                        }
                        this.mechanicCategoryItemName = this.$store.state.lossantosPage.configMechanicPrice[val];
                        if (val == 996) {
                            postNUI("openVehicleNeon", true);

                            setTimeout(() => {
                                for (let key in this.mechanicCategoryItemName.count) {
                                    if (key == 0) {
                                        this.mechanicCategoryItemName.count[key].price = 0;
                                    } else {
                                        this.mechanicCategoryItemName.count[key].price = this.$store.state.lossantosPage.configMechanicPrice[996].price;
                                    }
                                }
                            }, 10);
                        }
                        setTimeout(() => {
                            this.initSwiper();
                        }, 20);
                        return;
                    }

                    if (wheelTypes.includes(val)) {
                        postNUI("selectVehicleWheel", { name: val });
                        return;
                    }
                    if (val == 1000) {
                        postNUI("getVehicleExtra");
                        return;
                    }
                    postNUI("selectMechanicCategoryItem", val);
                }, 500);
            }
            return;
        },

        changeVehicleModification(modId, index, modName, price) {
            if (modId === 48) {
                this.$store.dispatch("soundPlay", "install");
                postNUI("setVehicleLivery", { id: index });
                return;
            }

            if (this.mechanicCategoryItemName.name == "extra") {
                this.$store.dispatch("soundPlay", "install");

                postNUI("setVehicleExtra", { id: index });

                return;
            }

            const tintName = ["tint-1", "tint0", "tint1", "tint2", "tint3", "tint4"];
            if (tintName.includes(modName)) {
                this.$store.dispatch("soundPlay", "install");
                postNUI("changeVehicleWindowTint", { index: index, modId: 994 });
                return;
            }
            const plName = ["pl1", "pl2", "pl3", "pl4", "pl5"];
            if (plName.includes(modName)) {
                this.$store.dispatch("soundPlay", "install");
                postNUI("changeVehiclePlayer", { index: index, modId: 993 });
                return;
            }
            const xenon = ["stockxenon", "xenon"];
            if (xenon.includes(modName)) {
                this.$store.dispatch("soundPlay", "install");
                postNUI("changeVehicleXenon", { index: index, modId: 997 });
                return;
            }
            const turbo = ["stockturbo", "turbo"];
            if (turbo.includes(modName)) {
                this.$store.dispatch("soundPlay", "install");

                postNUI("changeVehicleTurbo", { index: index, modId: 18 });
                return;
            }
            if (modName == "stockneon") {
                this.$store.dispatch("soundPlay", "install");
                postNUI("stockNeon");
                return;
            }

            const wheelName = {
                ["sportWheel"]: {
                    wheelId: 0,
                    index: index
                },
                ["muscleWheel"]: {
                    wheelId: 1,
                    index: index
                },
                ["lowriderWheel"]: {
                    wheelId: 2,
                    index: index
                },
                ["stockWheel"]: {
                    wheelId: 0,
                    index: index
                },
                ["suvWheel"]: {
                    wheelId: 3,
                    index: index
                },
                ["offroadWheel"]: {
                    wheelId: 4,
                    index: index
                },
                ["tunerWheel"]: {
                    wheelId: 5,
                    index: index
                },
                ["bikeWheel"]: {
                    wheelId: 6,
                    index: index
                },
                ["highendWheel"]: {
                    wheelId: 7,
                    index: index
                }
            };
            if (wheelName[modId]) {
                this.$store.dispatch("soundPlay", "install");
                if (modId == "stockWheel") {
                    postNUI("setVehicleWheelChange", { wheelId: wheelName[modId].wheelId, index: -1 });
                    return;
                }
                postNUI("setVehicleWheelChange", { wheelId: wheelName[modId].wheelId, index: wheelName[modId].index });
                return;
            }

            if (modName == "xenoncolor") {
                this.$store.state.lossantosPage.stanceMenu = false;
                this.$store.state.lossantosPage.vehicleCard = false;
                this.$store.state.lossantosPage.wheelColor = false;
                this.$store.state.lossantosPage.pearlescentcolor = false;
                this.$store.state.lossantosPage.openColorMenu = true;
                this.$store.state.lossantosPage.xeneonColor = true;
                return;
            }

            if (modName == "allcolor") {
                this.$store.state.lossantosPage.stanceMenu = false;
                this.$store.state.lossantosPage.vehicleCard = false;
                this.$store.state.lossantosPage.openColorMenu = true;
                this.$store.state.lossantosPage.wheelColor = false;
                this.$store.state.lossantosPage.pearlescentcolor = false;
                this.$store.state.lossantosPage.xeneonColor = false;
                return;
            }
            if (modName == "clearvehicle") {
                this.$store.dispatch("soundPlay", "spray");
                postNUI("clearVehicleColor");
            }

            if (modName == "extracolor") {
                this.$store.state.lossantosPage.stanceMenu = false;
                this.$store.state.lossantosPage.vehicleCard = false;
                this.$store.state.lossantosPage.openColorMenu = true;
                this.$store.state.lossantosPage.wheelColor = true;
                this.$store.state.lossantosPage.pearlescentcolor = false;
                this.$store.state.lossantosPage.xeneonColor = false;

                return;
            }
            if (modName == "pearlescentcolor") {
                this.$store.state.lossantosPage.stanceMenu = false;
                this.$store.state.lossantosPage.vehicleCard = false;
                this.$store.state.lossantosPage.openColorMenu = true;
                this.$store.state.lossantosPage.wheelColor = false;
                this.$store.state.lossantosPage.pearlescentcolor = true;
                this.$store.state.lossantosPage.xeneonColor = false;

                return;
            }

            if (!modName) {
                this.$store.dispatch("soundPlay", "install");
                postNUI("changeVehicleModification", { modId, index, price });
            }

            const modNamesToRefresh = ["wheeltype", "rimtype", "classicrim", "musclerim", "suvrim", "lowriderrim", "muscle", "sport", "lowrider", "suv", "offroad", "tuner", "motorcycle", "highend", "street", "track", "bike", "stock"];

            if (modName === "wheel") {
                this.refreshButton(991);
            } else if (modNamesToRefresh.includes(modName)) {
                this.refreshButton(modName);
            }
        },
        getInfoColor(index) {
            if (index == 1) {
                return "rgba(198, 255, 77, 0.65)";
            } else if (index == 2) {
                return "#FF9C65";
            } else if (index == 3) {
                return "rgba(198, 255, 77, 0.65)";
            } else if (index == 4 || index > 4) {
                return "rgba(77, 255, 105, 0.65)";
            }
        },
        eventHandler(event) {
            switch (event.data.action) {
                case "mechanicCategoryResult":
                    this.mechanicCategoryItemName = this.$store.state.lossantosPage.configMechanicPrice[event.data.payload.modId];
                    this.mechanicCategoryItemName.count = event.data.payload.modCount;
                    this.mechanicCategoryItemName.stock = event.data.payload.stock;
                    this.mechanicCategoryItemName.price = event.data.payload.price;
                    this.mechanicCategoryItemName.classPrice = event.data.payload.classPrice;
                    this.mechanicCategoryItemName.isFixedPrice = event.data.payload.isFixedPrice;
                    if (this.mechanicCategoryItemName.count <= 0) {
                        if (this.mechanicSwiperValue) {
                            this.mechanicSwiperValue.destroy(true, true);
                            return;
                        }
                    }

                    setTimeout(() => {
                        this.initSwiper();
                    }, 20);
                    break;
                case "hidebillplayer":
                    this.showBillPlayer = false;
                    break;
                case "updateStockNumber":
                    this.mechanicCategoryItemName = this.$store.state.lossantosPage.configMechanicPrice[event.data.payload.modId];
                    this.mechanicCategoryItemName.stock = event.data.payload.stock;

                    break;
                case "updateStockNumberDelete":
                    this.mechanicCategoryItemName = this.$store.state.lossantosPage.configMechanicPrice[event.data.payload.modId];
                    this.mechanicCategoryItemName.stock = event.data.payload.stock;
                    this.mechanicCategoryItemName = false;
                    this.currentCategory = false;
                    break;
                case "resultValue":
                    this.mechanicCategoryItemName = false;
                    break;
                case "updateVehicleCard":
                    this.$store.state.lossantosPage.vehicleCard = true;
                    this.$store.state.lossantosPage.vehicleCardData = event.data.payload;
                    break;

                case "close":
                    this.$store.state.activePage = "none";
                    this.$store.state.lossantosPage.vehicleCard = false;
                    break;
                case "updateWheelCount":
                    this.mechanicCategoryItemName = this.$store.state.lossantosPage.configMechanicPrice[event.data.payload.wheelType];
                    this.mechanicCategoryItemName.count = event.data.payload.wheelCount;
                    setTimeout(() => {
                        this.initSwiper();
                    }, 20);
                    break;

                case "updateExtraCount":
                    this.mechanicCategoryItemName = this.$store.state.lossantosPage.configMechanicPrice[1000];
                    this.mechanicCategoryItemName.count = event.data.payload.extra;
                    setTimeout(() => {
                        this.initSwiper();
                    }, 20);
                    break;
                case "cameraSettings":
                    this.cameraSettings = event.data.payload;

                    break;
                case "updateVehicleBasket":
                    this.$store.state.lossantosPage.vehicleBasket = event.data.payload;
                    break;
                case "updateNearbyPlayers":
                    this.nearbyPlayers = event.data.payload;
                    break;
                default:
                    break;
            }
        }
    },

    computed: {
        ...Vuex.mapState({
            locales: state => state.locales
        }),
        vehicleNotSupport() {
            if (this.mechanicCategoryItemName.count <= 0) {
                return true;
            } else {
                return false;
            }
        },

        totalPriceVehicleBasket() {
            if (!this.$store.state.lossantosPage.vehicleBasket || !this.$store.state.lossantosPage.vehicleBasket.length) return 0;
            return this.$store.state.lossantosPage.vehicleBasket.reduce((total, item) => total + parseInt(item.price, 10), 0);
        },
        totalPages() {
            return Math.ceil(this.currentCategory.length / 10);
        },
        currentItems() {
            return this.currentCategory.slice((this.currentPage - 1) * 10, this.currentPage * 10);
        },

        openColoris: function () {
            Coloris({
                theme: "polaroid",
                themeMode: "dark",
                alpha: false,
                formatToggle: false
            });
        },
        currentComponent() {
            if (this.$store.state.lossantosPage.stanceMenu) {
                return "stanceComponentsMenu";
            } else if (this.$store.state.lossantosPage.vehicleCard) {
                return "vehicleComponentsCard";
            } else if (this.$store.state.lossantosPage.openColorMenu) {
                return "vehicleColorMenu";
            }
            return null;
        }
    },

    watch: {},

    mounted() {
        window.addEventListener("message", this.eventHandler);

        // Upgrades
        this.$store.state.lossantosPage.mechanicCategories["upgrade"][0].locked = this.$store.state.lossantosPage.configMechanicPrice[11].locked;
        this.$store.state.lossantosPage.mechanicCategories["upgrade"][1].locked = this.$store.state.lossantosPage.configMechanicPrice[13].locked;
        this.$store.state.lossantosPage.mechanicCategories["upgrade"][2].locked = this.$store.state.lossantosPage.configMechanicPrice[15].locked;
        this.$store.state.lossantosPage.mechanicCategories["upgrade"][3].locked = this.$store.state.lossantosPage.configMechanicPrice[12].locked;
        this.$store.state.lossantosPage.mechanicCategories["upgrade"][4].locked = this.$store.state.lossantosPage.configMechanicPrice[16].locked;
        this.$store.state.lossantosPage.mechanicCategories["upgrade"][5].locked = this.$store.state.lossantosPage.configMechanicPrice[18].locked;
        this.$store.state.lossantosPage.mechanicCategories["upgrade"][6].locked = this.$store.state.lossantosPage.configMechanicPrice[39].locked;
        this.$store.state.lossantosPage.mechanicCategories["upgrade"][7].locked = this.$store.state.lossantosPage.configMechanicPrice[40].locked;
        this.$store.state.lossantosPage.mechanicCategories["upgrade"][8].locked = this.$store.state.lossantosPage.configMechanicPrice[41].locked;

        // body parts
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][0].locked = this.$store.state.lossantosPage.configMechanicPrice[0].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][1].locked = this.$store.state.lossantosPage.configMechanicPrice[1].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][2].locked = this.$store.state.lossantosPage.configMechanicPrice[2].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][3].locked = this.$store.state.lossantosPage.configMechanicPrice[3].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][4].locked = this.$store.state.lossantosPage.configMechanicPrice[4].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][5].locked = this.$store.state.lossantosPage.configMechanicPrice[5].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][6].locked = this.$store.state.lossantosPage.configMechanicPrice[7].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][7].locked = this.$store.state.lossantosPage.configMechanicPrice[8].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][8].locked = this.$store.state.lossantosPage.configMechanicPrice[10].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][9].locked = this.$store.state.lossantosPage.configMechanicPrice[46].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][10].locked = this.$store.state.lossantosPage.configMechanicPrice[23].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][11].locked = this.$store.state.lossantosPage.configMechanicPrice[993].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][12].locked = this.$store.state.lossantosPage.configMechanicPrice[999].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][13].locked = this.$store.state.lossantosPage.configMechanicPrice[42].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][14].locked = this.$store.state.lossantosPage.configMechanicPrice[43].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][15].locked = this.$store.state.lossantosPage.configMechanicPrice[994].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][16].locked = this.$store.state.lossantosPage.configMechanicPrice[44].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][17].locked = this.$store.state.lossantosPage.configMechanicPrice[6].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][18].locked = this.$store.state.lossantosPage.configMechanicPrice[27].locked;
        this.$store.state.lossantosPage.mechanicCategories["bodyparts"][19].locked = this.$store.state.lossantosPage.configMechanicPrice[38].locked;

        // interiors

        this.$store.state.lossantosPage.mechanicCategories["interiors"][0].locked = this.$store.state.lossantosPage.configMechanicPrice[29].locked;
        this.$store.state.lossantosPage.mechanicCategories["interiors"][1].locked = this.$store.state.lossantosPage.configMechanicPrice[31].locked;
        this.$store.state.lossantosPage.mechanicCategories["interiors"][2].locked = this.$store.state.lossantosPage.configMechanicPrice[32].locked;
        this.$store.state.lossantosPage.mechanicCategories["interiors"][3].locked = this.$store.state.lossantosPage.configMechanicPrice[33].locked;
        this.$store.state.lossantosPage.mechanicCategories["interiors"][4].locked = this.$store.state.lossantosPage.configMechanicPrice[30].locked;
        this.$store.state.lossantosPage.mechanicCategories["interiors"][5].locked = this.$store.state.lossantosPage.configMechanicPrice[34].locked;
        this.$store.state.lossantosPage.mechanicCategories["interiors"][6].locked = this.$store.state.lossantosPage.configMechanicPrice[28].locked;
        this.$store.state.lossantosPage.mechanicCategories["interiors"][7].locked = this.$store.state.lossantosPage.configMechanicPrice[45].locked;
        this.$store.state.lossantosPage.mechanicCategories["interiors"][8].locked = this.$store.state.lossantosPage.configMechanicPrice[37].locked;
        this.$store.state.lossantosPage.mechanicCategories["interiors"][9].locked = this.$store.state.lossantosPage.configMechanicPrice[36].locked;

        for (let key in this.$store.state.lossantosPage.configMechanicPrice[994].count) {
            if (key == 0) {
                this.$store.state.lossantosPage.configMechanicPrice[994].count[key].price = 0;
            } else {
                this.$store.state.lossantosPage.configMechanicPrice[994].count[key].price = this.$store.state.lossantosPage.configMechanicPrice[994].price;
            }
        }

        this.openPage = this.$store.state.activePage === "lossantosPage" ? true : false;
    },
    beforeDestroy() {
        window.removeEventListener("message", this.eventHandler);
    }
};

function hexToRgb(hex) {
    hex = hex.replace(/^#/, "");

    // Parse r, g, b values
    let bigint = parseInt(hex, 16);
    let r = (bigint >> 16) & 255;
    let g = (bigint >> 8) & 255;
    let b = bigint & 255;

    return [r, g, b];
}
