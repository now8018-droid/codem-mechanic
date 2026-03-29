const module = {
    namespaced: true,

    state: {
        playerInventory: [],
        bossInventory : [],
        itemImagesFolder : '',
        employees : [],
        ranks : [],
        money : 0,
        logs : [],
    },
    mutations: {
        setLogs(state, payload){
            state.logs = payload
        },
        setMoney(state, payload){
            state.money = payload
        },
        setRanks(state, payload){
            state.ranks = payload
            state.ranks = state.ranks.sort((a, b) =>{
                return b.grade - a.grade
            })
        },
        setPlayerInventory(state, payload){
            state.playerInventory = payload
        },
        setBossInventory(state, payload){
            state.bossInventory = payload
        },
        setItemImagesFolder(state, payload){
            state.itemImagesFolder = payload
        },
        setEmployees(state, payload){
            state.employees = payload
        },
    },
};

export default module;
