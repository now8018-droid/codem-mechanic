import importTemplate from "../../js/util/importTemplate.js";

export default {
    template: await importTemplate("pages/jobmenu/index.html"),

    data: () => ({
        baseJobMenuCategory: [
            {
                name: "cleanthevehicle",
                label: "Clean the vehicle"
            },
            {
                name: "repairthevehicle",
                label: "Repair the vehicle"
            },
            {
                name: "pustthevehicle",
                label: "Flip the vehicle"
            },
            {
                name: "getnpcmission",
                label: "Get NPC Mission"
            }
        ]
    }),
    methods: {
        jobMenuOption(val) {
            postNUI("jobMenuOption", val);
        }
    },

    computed: {
        ...Vuex.mapState({
            locales: state => state.locales,
            enableNPCMissions: state => state.enableNPCMissions
        }),
        jobMenuCategory() {
            if (this.enableNPCMissions) {
                return this.baseJobMenuCategory;
            } else {
                return this.baseJobMenuCategory.filter(item => item.name !== "getnpcmission");
            }
        }
    },

    mounted() {
        window.addEventListener("message", this.eventHandler);
        this.baseJobMenuCategory.forEach(item => {
            if (item.name == "cleanthevehicle") {
                item.label = this.locales.CLEAN_VEHICLE;
            }
            if (item.name == "repairthevehicle") {
                item.label = this.locales.REPAIR_VEHICLE;
            }
            if (item.name == "pustthevehicle") {
                item.label = this.locales.FLIP_VEHICLE;
            }
            if (item.name == "getnpcmission") {
                item.label = this.locales.GET_NPC_MISSION;
            }
        });
    },
    beforeDestroy() {
        window.removeEventListener("message", this.eventHandler);
    }
};
