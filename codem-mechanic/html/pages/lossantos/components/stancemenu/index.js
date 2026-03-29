import importTemplate from "../../../../js/util/importTemplate.js";

export default {
    template: await importTemplate("./pages/lossantos/components/stancemenu/index.html"),
    components: {},

    data: () => ({
        stanceData: [
            { name: "height", value: 0.0, label: "Height", min: 0.0, max: 10.0, step: 1 },
            { name: "offsetFront", value: 0.0, label: "Offset Front", min: 6, max: 9, step: 0.1 },
            { name: "offsetRear", value: 0.0, label: "Offset Rear", min: 6.0, max: 9, step: 0.1 },
            { name: "rotationFront", value: 0.0, label: "Rotation Front", min: 0.0, max: 0.3, step: 0.1 },
            { name: "rotationRear", value: 0.0, label: "Rotation Rear", min: 0.0, max: 0.3, step: 0.1 }
            // { name: "wheelSize", value: 0.0, label: "Wheel Size", min: 0.1, max: 1.5, step: 0.1 },
            // { name: "wheelHeight", value: 0.0, label: "Wheel Height", min: 0.2, max: 1.5, step: 0.1 }
        ]
    }),
    methods: {
        stanceMenuClose() {
            this.$store.state.lossantosPage.stanceMenu = false;
            this.$store.state.lossantosPage.vehicleCard = true;
            this.$store.state.lossantosPage.openColorMenu = false;
        },
        saveStance() {
            postNUI("saveStance");
        },
        updateSlider(data) {
            const refName = `mySlider-${data.name}`;

            const sliderElement = this.$refs[refName][0];
            if (sliderElement) {
                let percentage = ((data.value - data.min) / (data.max - data.min)) * 100;
                percentage = Math.max(0, Math.min(percentage, 100));

                sliderElement.style.setProperty("--pos", percentage + "%");
                postNUI("setVehicleStance", { name: data.name, num: data.value });
            } else {
                console.error(`Slider element for ${data.name} not found!`);
            }
        }
    },
    computed: {},
    mounted() {}
};
