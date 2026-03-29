import importTemplate from "../../../../js/util/importTemplate.js";

export default {
    template: await importTemplate("./pages/lossantos/components/vehiclecard/index.html"),
    components: {},

    data: () => ({
        vehicleData: false
    }),
    methods: {
        specMenuClose() {}
    },
    computed: {
        ...Vuex.mapState({
            locales : state => state.locales,

        }),
    },
    mounted() {}
};
