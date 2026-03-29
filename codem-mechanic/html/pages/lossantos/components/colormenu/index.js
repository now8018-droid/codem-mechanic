import importTemplate from "../../../../js/util/importTemplate.js";

export default {
    template: await importTemplate("./pages/lossantos/components/colormenu/index.html"),
    components: {},

    data: () => ({
        vehicleData: false,
        selectedData : {},
        xeneonColorData: {
            White: {
                label: "White",
                colors: [
                    { index: 0, label: "White" }
                ]
            },
            Blue : {
                label: "Blue",
                colors: [
                    { index: 1, label: "Blue" }
                ]
            },
            Electric_Blue : {
                label: "Electric Blue",
                colors: [
                    { index: 2, label: "Electric Blue" }
                ]
            },
            Mint_Green : {
                label: "Mint Green",
                colors: [
                    { index: 3, label: "Mint Green" }
                ]
            },
            Lime_Green : {
                label: "Lime Green",
                colors: [
                    { index: 4, label: "Lime Green" }
                ]
            },
            Yellow : {
                label : "Yellow",
                colors: [
                    { index: 5, label: "Yellow" }
                ]
            },
            Golden_Shower : {
                label : "Golden Shower",
                colors : [
                    { index: 6, label: "Golden Shower" }
                ]
            },
            Orange: {
                label: "Orange",
                colors: [
                    { index: 7, label: "Orange" }
                ]
            },
            Red: {
                label: "Red",
                colors: [
                    { index: 8, label: "Red" }
                ]
            },
            Pony_Pink: {
                label: "Pony Pink",
                colors: [
                    { index: 9, label: "Pony Pink" }
                ]
            },
            Hot_Pink: {
                label: "Hot Pink",
                colors: [
                    { index: 10, label: "Hot Pink" }
                ]
            },
            Purple: {
                label: "Purple",
                colors: [
                    { index: 11, label: "Purple" }
                ]
            },
            Blacklight: {
                label: "Blacklight",
                colors: [
                    { index: 12, label: "Blacklight" }
                ]
            },
        },
        mechanicColorData: {
            chrome: {
                label: "Chrome",
                colors: [
                    { index: 117, label: "Brus Chrome" },
                    { index: 118, label: "Black Chrome" },
                    { index: 119, label: "Brus Aluminum" },
                    { index: 120, label: "Chrome" }
                ]
            },
            brown: {
                label: "Brown",
                colors: [
                    { index: 45, label: "Copper" },
                    { index: 47, label: "Light Brown" },
                    { index: 48, label: "Dark Brown" },
                    { index: 90, label: "Bronze" },
                    { index: 94, label: "Brown Metallic" },
                    { index: 95, label: "Expresso" },
                    { index: 96, label: "Chocolate" },
                    { index: 97, label: "Terracotta" },
                    { index: 98, label: "Marble" },
                    { index: 99, label: "Sand" },
                    { index: 100, label: "Sepia" },
                    { index: 101, label: "Bison" },
                    { index: 102, label: "Palm" },
                    { index: 103, label: "Caramel" },
                    { index: 104, label: "Rust" },
                    { index: 105, label: "Chestnut" },
                    { index: 108, label: "Brown" },
                    { index: 109, label: "Hazelnut" },
                    { index: 110, label: "Shell" },
                    { index: 114, label: "Mahogany" },
                    { index: 115, label: "Cauldron" },
                    { index: 116, label: "Blond" },
                    { index: 129, label: "Gravel" },
                    { index: 153, label: "Dark Earth" },
                    { index: 154, label: "Desert" }
                ]
            },

            gold: {
                label: "Gold",
                colors: [
                    { index: 158, label: "Pure Gold" },
                    { index: 159, label: "Brushed Gold" },
                    { index: 160, label: "Gold" },

                    { index: 37, label: "Gold" }
                ]
            },
            purple: {
                label: "Purple",
                colors: [
                    { index: 71, label: "Indigo" },
                    { index: 72, label: "Deeppurple" },
                    { index: 76, label: "Darkviolet" },
                    { index: 81, label: "Amethyst" },
                    { index: 142, label: "Mystical Violet" },
                    { index: 145, label: "Purple Metallic" },
                    { index: 148, label: "Matte Violet" },
                    { index: 149, label: "Matte Deep Purple" }
                ]
            },
            orange: {
                label: "Orange",
                colors: [
                    { index: 36, label: "Tangerine" },
                    { index: 38, label: "Orange" },
                    { index: 41, label: "Matte Orange" },
                    { index: 123, label: "Light Orange" },
                    { index: 124, label: "Peach" },
                    { index: 130, label: "Pumpkin" },
                    { index: 138, label: "Orangelambo" }
                ]
            },
            black: {
                label: "Black",
                colors: [
                    { index: 0, label: "Black" },
                    { index: 1, label: "Graphite Black" },
                    { index: 2, label: "Black Steel" },
                    { index: 3, label: "Dark Steel" },
                    { index: 11, label: "Anth" },
                    { index: 12, label: "Matte Black" },
                    { index: 15, label: "Dark Night" },
                    { index: 16, label: "Dark Night" },
                    { index: 21, label: "Midnight Silver" },
                    { index: 147, label: "Carbon" }
                ]
            },
            white: {
                label: "White",
                colors: [
                    { index: 106, label: "Vanilla" },
                    { index: 107, label: "Creme" },
                    { index: 111, label: "White" },
                    { index: 112, label: "Polar White" },
                    { index: 113, label: "Beige" },
                    { index: 121, label: "Mattewhite" },
                    { index: 122, label: "Snow" },
                    { index: 131, label: "Cotton" },
                    { index: 132, label: "Alabaster" },
                    { index: 134, label: "Purewhite" }
                ]
            },
            green: {
                label: "Green",
                colors: [
                    { index: 49, label: "Met Dark Green" },
                    { index: 50, label: "Rally Green" },
                    { index: 51, label: "Pine Green" },
                    { index: 52, label: "Olive Green" },
                    { index: 53, label: "Light Green" },
                    { index: 55, label: "Lime Green" },
                    { index: 56, label: "Forest Green" },
                    { index: 57, label: "Lawn Green" },
                    { index: 58, label: "Imperial Green" },
                    { index: 59, label: "Green Bottle" },
                    { index: 92, label: "Citrus Green" },
                    { index: 125, label: "Green Anis" },
                    { index: 128, label: "Khaki" },
                    { index: 133, label: "Army Green" },
                    { index: 151, label: "Dark Green" },
                    { index: 152, label: "Hunter Green" },
                    { index: 155, label: "Matte Foilage Green" }
                ]
            },
            yellow: {
                label: "Yellow",
                colors: [
                    { index: 42, label: "Yellow" },
                    { index: 88, label: "Wheat" },
                    { index: 89, label: "Race Yellow" },
                    { index: 91, label: "Pale Yellow" },
                    { index: 126, label: "Light Yellow" }
                ]
            },
            gray: {
                label: "Gray",
                colors: [
                    { index: 0, label: "Black" },
                    { index: 1, label: "Graphite Black" },
                    { index: 2, label: "Black Steel" },
                    { index: 3, label: "Dark Steel" },
                    { index: 11, label: "Anth" },
                    { index: 12, label: "Matte Black" },
                    { index: 15, label: "Dark Night" },
                    { index: 16, label: "Dark Night" },
                    { index: 21, label: "Midnight Silver" },
                    { index: 147, label: "Carbon" }
                ]
            },
            red: {
                label: "Red",
                colors: [
                    { index: 27, label: "Red" },
                    { index: 28, label: "Torino Red" },
                    { index: 29, label: "Poppy" },
                    { index: 30, label: "Copper Red" },
                    { index: 31, label: "Cardinal" },
                    { index: 32, label: "Brick" },
                    { index: 33, label: "Garnet" },
                    { index: 34, label: "Cabernet" },
                    { index: 35, label: "Candy" },
                    { index: 39, label: "Matte Red" },
                    { index: 40, label: "Dark Red" },
                    { index: 43, label: "Red Pulp" },
                    { index: 44, label: "Bril Red" },
                    { index: 46, label: "Pale Red" },
                    { index: 143, label: "Wine Red" },
                    { index: 150, label: "Volcano" }
                ]
            },
            pink: {
                label: "Pink",
                colors: [
                    { index: 135, label: "Electric Pink" },
                    { index: 136, label: "Salmon" },
                    { index: 137, label: "Sugarplum" }
                ]
            },
            blue: {
                label: "Blue",
                colors: [
                    { index: 54, label: "Topaz" },
                    { index: 60, label: "Light Blue" },
                    { index: 61, label: "Galaxy Blue" },
                    { index: 62, label: "Dark Blue" },
                    { index: 63, label: "Azure" },
                    { index: 64, label: "Navy Blue" },
                    { index: 65, label: "Lapis" },
                    { index: 67, label: "Blue Diamond" },
                    { index: 68, label: "Surfer" },
                    { index: 69, label: "Pastel Blue" },
                    { index: 70, label: "Celeste Blue" },
                    { index: 73, label: "Rally Blue" },
                    { index: 74, label: "Blue Paradise" },
                    { index: 75, label: "Blue Night" },
                    { index: 77, label: "Cyan Blue" },
                    { index: 78, label: "Cobalt" },
                    { index: 79, label: "Electric Blue" },
                    { index: 80, label: "Horizon Blue" },
                    { index: 82, label: "Metallic Blue" },
                    { index: 83, label: "Aquamarine" },
                    { index: 84, label: "Blue Agathe" },
                    { index: 85, label: "Zirconium" },
                    { index: 86, label: "Spinel" },
                    { index: 87, label: "Tourmaline" },
                    { index: 127, label: "Paradise" },
                    { index: 140, label: "Bubble Gum" },
                    { index: 141, label: "Midnight Blue" },
                    { index: 146, label: "Forbidden Blue" },
                    { index: 157, label: "Glacier Blue" }
                ]
            },
            chamelon: {
                label: "Chamelon",
                colors: [
                    { index: 161, label: "Monochrome" },
                    { index: 162, label: "Night & Day" },
                    { index: 163, label: "Verlierer" },
                    { index: 164, label: "Sprunk" },
                    { index: 165, label: "Vice City" },
                    { index: 166, label: "Synthwave Night" },
                    { index: 167, label: "Four Seasons" },
                    { index: 168, label: "Maisonette 9 Throwback" },
                    { index: 169, label: "Bubblegum" },
                    { index: 170, label: "Full Rainbow" },
                    { index: 171, label: "Sunset" },
                    { index: 172, label: "The Seven" },
                    { index: 173, label: "Kamen Rider" },
                    { index: 174, label: "Chromatic Aberration" },
                    { index: 175, label: "Christmas" },
                    { index: 176, label: "Temperature" }
                ]
            }
        }
    }),
    methods: {
        initColorSwiper() {
            for (let ref in this.$refs) {
                if (ref.startsWith("colorSwiper-")) {
                    const categoryName = ref.split("-")[1];
                    this.colorSwiper = new Swiper(this.$refs[ref][0], {
                        slidesPerView: 1,

                        loop: false,
                        navigation: {
                            nextEl: `.nextColorBtn-${categoryName}`,
                            prevEl: `.backColorBtn-${categoryName}`
                        }
                    });
                }
            }
        },
        allColorChange(index) {
            if (this.$store.state.lossantosPage.wheelColor) {
                this.$store.dispatch("soundPlay", "spray");
                postNUI("setVehicleColor", { modname: "extracolor", color: index });
            } else if (this.$store.state.lossantosPage.pearlescentcolor) {
                this.$store.dispatch("soundPlay", "spray");
                postNUI("setVehicleColor", { modname: "pearlescentcolor", color: index });
            } else if (this.$store.state.lossantosPage.xeneonColor) {
                this.$store.dispatch("soundPlay", "spray");
                postNUI("setVehicleColor", { modname: "xenoncolor", color: index });
            }else {
                this.$store.dispatch("soundPlay", "spray");
                postNUI("setVehicleColor", { modname: "allcolor", color: index });
            }
        },
        closeColorMenu() {
            this.$store.state.lossantosPage.stanceMenu = false;
            this.$store.state.lossantosPage.vehicleCard = true;
            this.$store.state.lossantosPage.openColorMenu = false;
            this.$store.state.lossantosPage.wheelColor = false;
        }
    },
    computed: {
        ...Vuex.mapState({
            locales: state => state.locales
        })
    },
    mounted() {
        if (this.$store.state.lossantosPage.openColorMenu) {
            setTimeout(() => {
                this.initColorSwiper();
            }, 50);
        }

        if (this.$store.state.lossantosPage.xeneonColor) {
            this.selectedData = this.xeneonColorData;
        }else {
            this.selectedData = this.mechanicColorData;
        }

        this.xeneonColorData["White"].colors[0].label = this.locales.WHITE;
        this.xeneonColorData["Blue"].colors[0].label = this.locales.BLUE;
        this.xeneonColorData["Electric_Blue"].colors[0].label = this.locales.ELECTRICBLUE;
        this.xeneonColorData["Mint_Green"].colors[0].label = this.locales.MINTGREEN;
        this.xeneonColorData["Lime_Green"].colors[0].label = this.locales.LIMEGREEN;
        this.xeneonColorData["Yellow"].colors[0].label = this.locales.YELLOW;
        this.xeneonColorData["Golden_Shower"].colors[0].label = this.locales.GOLDEN_SHOWER;
        this.xeneonColorData["Orange"].colors[0].label = this.locales.ORANGE;
        this.xeneonColorData["Red"].colors[0].label = this.locales.RED;
        this.xeneonColorData["Pony_Pink"].colors[0].label = this.locales.PONY_PINK;
        this.xeneonColorData["Hot_Pink"].colors[0].label = this.locales.HOT_PINK;
        this.xeneonColorData["Purple"].colors[0].label = this.locales.PURPLE;
        this.xeneonColorData["Blacklight"].colors[0].label = this.locales.BLACKLIGHT;
        

        this.mechanicColorData["chrome"].label = this.locales.CHROME;
        this.mechanicColorData["chrome"].colors[0].label = this.locales.CHROME;
        this.mechanicColorData["chrome"].colors[1].label = this.locales.BLACKCHROME;
        this.mechanicColorData["chrome"].colors[2].label = this.locales.BRUSHALUMINUM;

        this.mechanicColorData["brown"].label = this.locales.BROWN;
        this.mechanicColorData["brown"].colors[0].label = this.locales.COPPER;
        this.mechanicColorData["brown"].colors[1].label = this.locales.LIGHTBROWN;
        this.mechanicColorData["brown"].colors[2].label = this.locales.DARKBROWN;
        this.mechanicColorData["brown"].colors[3].label = this.locales.BRONZE;
        this.mechanicColorData["brown"].colors[4].label = this.locales.BROWNMETALLIC;
        this.mechanicColorData["brown"].colors[5].label = this.locales.EXPRESSO;
        this.mechanicColorData["brown"].colors[6].label = this.locales.CHOCOLATE;
        this.mechanicColorData["brown"].colors[7].label = this.locales.TERRACOTTA;
        this.mechanicColorData["brown"].colors[8].label = this.locales.MARBLE;
        this.mechanicColorData["brown"].colors[9].label = this.locales.SAND;
        this.mechanicColorData["brown"].colors[10].label = this.locales.SEPIA;
        this.mechanicColorData["brown"].colors[11].label = this.locales.BISON;
        this.mechanicColorData["brown"].colors[12].label = this.locales.PALM;
        this.mechanicColorData["brown"].colors[13].label = this.locales.CARAMEL;
        this.mechanicColorData["brown"].colors[14].label = this.locales.RUST;
        this.mechanicColorData["brown"].colors[15].label = this.locales.CHESTNUT;
        this.mechanicColorData["brown"].colors[16].label = this.locales.BROWN;
        this.mechanicColorData["brown"].colors[17].label = this.locales.HAZELNUT;
        this.mechanicColorData["brown"].colors[18].label = this.locales.SHELL;
        this.mechanicColorData["brown"].colors[19].label = this.locales.MAHOGANY;
        this.mechanicColorData["brown"].colors[20].label = this.locales.CAULDRON;
        this.mechanicColorData["brown"].colors[21].label = this.locales.BLOND;
        this.mechanicColorData["brown"].colors[22].label = this.locales.GRAVEL;
        this.mechanicColorData["brown"].colors[23].label = this.locales.DARKEARTH;
        this.mechanicColorData["brown"].colors[24].label = this.locales.DESERT;

        this.mechanicColorData["gold"].label = this.locales.GOLD;
        this.mechanicColorData["gold"].colors[0].label = this.locales.PUREGOLD;
        this.mechanicColorData["gold"].colors[1].label = this.locales.BRUSHEDGOLD;
        this.mechanicColorData["gold"].colors[2].label = this.locales.GOLD;
        this.mechanicColorData["gold"].colors[3].label = this.locales.GOLDLEST;

        this.mechanicColorData["purple"].label = this.locales.PURPLE;
        this.mechanicColorData["purple"].colors[0].label = this.locales.INDIGO;
        this.mechanicColorData["purple"].colors[1].label = this.locales.DEEPPURPLE;
        this.mechanicColorData["purple"].colors[2].label = this.locales.DARKVIOLET;
        this.mechanicColorData["purple"].colors[3].label = this.locales.AMETHYST;
        this.mechanicColorData["purple"].colors[4].label = this.locales.MYSTICALVIOLET;
        this.mechanicColorData["purple"].colors[5].label = this.locales.PURPLEMETALLIC;
        this.mechanicColorData["purple"].colors[6].label = this.locales.MATTEVIOLET;
        this.mechanicColorData["purple"].colors[7].label = this.locales.MATTEDEEPPURPLE;

        this.mechanicColorData["orange"].label = this.locales.ORANGE;
        this.mechanicColorData["orange"].colors[0].label = this.locales.TANGERINE;
        this.mechanicColorData["orange"].colors[1].label = this.locales.ORANGE;
        this.mechanicColorData["orange"].colors[2].label = this.locales.MATTEORANGE;
        this.mechanicColorData["orange"].colors[3].label = this.locales.LIGHTORANGE;
        this.mechanicColorData["orange"].colors[4].label = this.locales.PEACH;
        this.mechanicColorData["orange"].colors[5].label = this.locales.PUMPKIN;
        this.mechanicColorData["orange"].colors[6].label = this.locales.ORANGELAMBO;

        this.mechanicColorData["black"].label = this.locales.BLACK;
        this.mechanicColorData["black"].colors[0].label = this.locales.BLACK;
        this.mechanicColorData["black"].colors[1].label = this.locales.GRAPHITEBLACK;
        this.mechanicColorData["black"].colors[2].label = this.locales.BLACKSTEEL;
        this.mechanicColorData["black"].colors[3].label = this.locales.DARKSTEEL;
        this.mechanicColorData["black"].colors[4].label = this.locales.ANTH;
        this.mechanicColorData["black"].colors[5].label = this.locales.MATTEBLACK;
        this.mechanicColorData["black"].colors[6].label = this.locales.DARKNIGHT;
        this.mechanicColorData["black"].colors[7].label = this.locales.DARKNIGHT2;
        this.mechanicColorData["black"].colors[8].label = this.locales.MIDNIGHTSILVER;
        this.mechanicColorData["black"].colors[9].label = this.locales.CARBON;

        this.mechanicColorData["white"].label = this.locales.WHITE;
        this.mechanicColorData["white"].colors[0].label = this.locales.VANILLA;
        this.mechanicColorData["white"].colors[1].label = this.locales.CREME;
        this.mechanicColorData["white"].colors[2].label = this.locales.WHITE;
        this.mechanicColorData["white"].colors[3].label = this.locales.POLARWHITE;
        this.mechanicColorData["white"].colors[4].label = this.locales.BEIGE;
        this.mechanicColorData["white"].colors[5].label = this.locales.MATTEWHITE;
        this.mechanicColorData["white"].colors[6].label = this.locales.SNOW;
        this.mechanicColorData["white"].colors[7].label = this.locales.COTTON;
        this.mechanicColorData["white"].colors[8].label = this.locales.ALABASTER;
        this.mechanicColorData["white"].colors[9].label = this.locales.PUREWHITE;

        this.mechanicColorData["green"].label = this.locales.GREEN;
        this.mechanicColorData["green"].colors[0].label = this.locales.METDARKGREEN;
        this.mechanicColorData["green"].colors[1].label = this.locales.RALLYGREEN;
        this.mechanicColorData["green"].colors[2].label = this.locales.PINEGREEN;
        this.mechanicColorData["green"].colors[3].label = this.locales.OLIVEGREEN;
        this.mechanicColorData["green"].colors[4].label = this.locales.LIGHTGREEN;
        this.mechanicColorData["green"].colors[5].label = this.locales.LIMEGREEN;
        this.mechanicColorData["green"].colors[6].label = this.locales.FORESTGREEN;
        this.mechanicColorData["green"].colors[7].label = this.locales.LAWNGREEN;
        this.mechanicColorData["green"].colors[8].label = this.locales.IMPERIALGREEN;
        this.mechanicColorData["green"].colors[9].label = this.locales.GREENBOTTLE;
        this.mechanicColorData["green"].colors[10].label = this.locales.CITRUSGREEN;
        this.mechanicColorData["green"].colors[11].label = this.locales.GREENANIS;
        this.mechanicColorData["green"].colors[12].label = this.locales.KHAKI;
        this.mechanicColorData["green"].colors[13].label = this.locales.ARMYGREEN;
        this.mechanicColorData["green"].colors[14].label = this.locales.DARKGREEN;
        this.mechanicColorData["green"].colors[15].label = this.locales.HUNTERGREEN;
        this.mechanicColorData["green"].colors[16].label = this.locales.MATTEFOILAGEGREEN;

        this.mechanicColorData["yellow"].label = this.locales.YELLOW;
        this.mechanicColorData["yellow"].colors[0].label = this.locales.YELLOW;
        this.mechanicColorData["yellow"].colors[1].label = this.locales.WHEAT;
        this.mechanicColorData["yellow"].colors[2].label = this.locales.RACEYELLOW;
        this.mechanicColorData["yellow"].colors[3].label = this.locales.PALEYELLOW;
        this.mechanicColorData["yellow"].colors[4].label = this.locales.LIGHTYELLOW;

        this.mechanicColorData["red"].label = this.locales.RED;
        this.mechanicColorData["red"].colors[0].label = this.locales.RED;
        this.mechanicColorData["red"].colors[1].label = this.locales.TORINORED;
        this.mechanicColorData["red"].colors[2].label = this.locales.POPPY;
        this.mechanicColorData["red"].colors[3].label = this.locales.COPPERRED;
        this.mechanicColorData["red"].colors[4].label = this.locales.CARDINAL;
        this.mechanicColorData["red"].colors[5].label = this.locales.BRICK;
        this.mechanicColorData["red"].colors[6].label = this.locales.GARNET;
        this.mechanicColorData["red"].colors[7].label = this.locales.CABERNET;
        this.mechanicColorData["red"].colors[8].label = this.locales.CANDY;
        this.mechanicColorData["red"].colors[9].label = this.locales.MATTERED;
        this.mechanicColorData["red"].colors[10].label = this.locales.DARKRED;
        this.mechanicColorData["red"].colors[11].label = this.locales.REDPULP;
        this.mechanicColorData["red"].colors[12].label = this.locales.BRILRED;
        this.mechanicColorData["red"].colors[13].label = this.locales.PALERED;
        this.mechanicColorData["red"].colors[14].label = this.locales.WINERED;
        this.mechanicColorData["red"].colors[15].label = this.locales.VOLCANO;

        this.mechanicColorData["pink"].label = this.locales.PINK;
        this.mechanicColorData["pink"].colors[0].label = this.locales.ELECTRICPINK;
        this.mechanicColorData["pink"].colors[1].label = this.locales.SALMON;
        this.mechanicColorData["pink"].colors[2].label = this.locales.SUGARPLUM;

        this.mechanicColorData["blue"].label = this.locales.BLUE;
        this.mechanicColorData["blue"].colors[0].label = this.locales.TOPAZ;
        this.mechanicColorData["blue"].colors[1].label = this.locales.LIGHTBLUE;
        this.mechanicColorData["blue"].colors[2].label = this.locales.GALAXYBLUE;
        this.mechanicColorData["blue"].colors[3].label = this.locales.DARKBLUE;
        this.mechanicColorData["blue"].colors[4].label = this.locales.AZURE;
        this.mechanicColorData["blue"].colors[5].label = this.locales.NAVYBLUE;
        this.mechanicColorData["blue"].colors[6].label = this.locales.LAPIS;
        this.mechanicColorData["blue"].colors[7].label = this.locales.BLUEDIAMOND;
        this.mechanicColorData["blue"].colors[8].label = this.locales.SURFER;
        this.mechanicColorData["blue"].colors[9].label = this.locales.PASTELBLUE;
        this.mechanicColorData["blue"].colors[10].label = this.locales.CELESTEBLUE;
        this.mechanicColorData["blue"].colors[11].label = this.locales.RALLYBLUE;
        this.mechanicColorData["blue"].colors[12].label = this.locales.BLUEPARADISE;
        this.mechanicColorData["blue"].colors[13].label = this.locales.BLUENIGHT;
        this.mechanicColorData["blue"].colors[14].label = this.locales.CYANBLUE;
        this.mechanicColorData["blue"].colors[15].label = this.locales.COBALT;
        this.mechanicColorData["blue"].colors[16].label = this.locales.ELECTRICBLUE;
        this.mechanicColorData["blue"].colors[17].label = this.locales.HORIZONBLUE;
        this.mechanicColorData["blue"].colors[18].label = this.locales.METALLICBLUE;
        this.mechanicColorData["blue"].colors[19].label = this.locales.AQUAMARINE;
        this.mechanicColorData["blue"].colors[20].label = this.locales.BLUEAGATHE;
        this.mechanicColorData["blue"].colors[21].label = this.locales.ZIRCONIUM;
        this.mechanicColorData["blue"].colors[22].label = this.locales.SPINEL;
        this.mechanicColorData["blue"].colors[23].label = this.locales.TOURMALINE;
        this.mechanicColorData["blue"].colors[24].label = this.locales.PARADISE;
        this.mechanicColorData["blue"].colors[25].label = this.locales.BUBBLEGUM;
        this.mechanicColorData["blue"].colors[26].label = this.locales.MIDNIGHTBLUE;
        this.mechanicColorData["blue"].colors[27].label = this.locales.FORBIDDENBLUE;
        this.mechanicColorData["blue"].colors[28].label = this.locales.GLACIERBLUE;

        this.mechanicColorData["chamelon"].label = this.locales.CHAMELEON;
        this.mechanicColorData["chamelon"].colors[0].label = this.locales.MONOCHROME;
        this.mechanicColorData["chamelon"].colors[1].label = this.locales.NIGHTDAY;
        this.mechanicColorData["chamelon"].colors[2].label = this.locales.VERLIERER;
        this.mechanicColorData["chamelon"].colors[3].label = this.locales.SPRUNK;
        this.mechanicColorData["chamelon"].colors[4].label = this.locales.VICECITY;
        this.mechanicColorData["chamelon"].colors[5].label = this.locales.SYNTHWAVENIGHT;
        this.mechanicColorData["chamelon"].colors[6].label = this.locales.FOURSEASONS;
        this.mechanicColorData["chamelon"].colors[7].label = this.locales.MAISONETTENINE;
        this.mechanicColorData["chamelon"].colors[8].label = this.locales.BUBBLEGUM;
        this.mechanicColorData["chamelon"].colors[9].label = this.locales.FULLRAINBOW;
        this.mechanicColorData["chamelon"].colors[10].label = this.locales.SUNSET;
        this.mechanicColorData["chamelon"].colors[11].label = this.locales.THESEVEN;
        this.mechanicColorData["chamelon"].colors[12].label = this.locales.KAMENRIDER;
        this.mechanicColorData["chamelon"].colors[13].label = this.locales.CHROMATICABERRATION;
        this.mechanicColorData["chamelon"].colors[14].label = this.locales.CHRISTMAS;
        this.mechanicColorData["chamelon"].colors[15].label = this.locales.TEMPERATURE;

    }
};
