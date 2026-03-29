const module = {
    namespaced: true,

    state: {
        vehicleCard: false,
        vehicleCardData: false,
        stanceMenu: false,
        openColorMenu: false,
        xeneonColor : false,
        configMechanicPrice: false,
        mechanicCategories: false,
        vehicleBasket: false,
        wheelColor: false,
        pearlescentcolor: false,
        mechanicVault: 0,
        mechanicLabel: false,
        categoryLocked: false,
        currentThema: "white",

        currentColor: {
            red: "#FF6262",
            blue: "#62A1FF",
            orange: "#FF9A62",
            white: "#FFFFFF",
            purple: "#bc84ff"
        }
    }
};

export default module;
