import importTemplate from "../../js/util/importTemplate.js";

export default {
    template: await importTemplate("pages/bossmenu/index.html"),

    data: () => ({
        currentBossPage: 'ranks',
        editPermissions: false,
        myRank: {},
        inventoryInputAmount: null,
        hirePlayerId: null,
        selectedEmployee: false,
        selectedRank: false,
        moneyAmount: null,
        filterLog : '',
    }),
    watch: {
        playerInventory() {
            this.RefreshDragDrop()
        },
        bossInventory() {
            this.RefreshDragDrop()
        },
        employees(data) {
            if (this.selectedEmployee) {
                let found = false
                data.forEach(el => {
                    if (el.identifier == this.selectedEmployee.identifier) {
                        this.selectedEmployee = el
                        found = true
                    }
                });
                if (!found) {
                    this.selectedEmployee = false
                }
            }
        },
        ranks(data) {
            if (this.selectedRank) {
                let found = false
                data.forEach(el => {
                    if (el.grade == this.selectedRank.grade) {
                        this.selectedRank = el
                        found = true
                    }
                });
                if (!found) {
                    this.selectedRank = false
                }
            }
        }
    },
    methods: {

        DepositMoney() {
            if (!isNaN(this.moneyAmount) && this.moneyAmount > 0) {
                postNUI("DepositMoney", {
                    amount: this.moneyAmount
                })
            }
        },
        CheckPermission(name) {
            if (this.myRank.isBoss || this.myRank.permissions[name]) {
                return true
            }
            return false
        },
        WithdrawMoney() {
            if (!isNaN(this.moneyAmount) && this.moneyAmount > 0) {
                postNUI("WithdrawMoney", {
                    amount: this.moneyAmount
                })
            }
        },
        PromotePlayer() {
            if (this.selectedEmployee) {
                postNUI("PromotePlayer", {
                    identifier: this.selectedEmployee.identifier
                })
            }
        },
        GetEmployeesInRank(grade) {
            return this.employees.filter((employee) => {
                return employee.grade_level == grade
            })
        },
        DemotePlayer() {
            if (this.selectedEmployee) {
                postNUI("DemotePlayer", {
                    identifier: this.selectedEmployee.identifier
                })
            }
        },
        FirePlayer() {
            if (this.selectedEmployee) {
                postNUI("FirePlayer", {
                    identifier: this.selectedEmployee.identifier
                })
            }
        },

        SelectEmployee(data) {
            if (this.CheckPermission() == false) {
                this.$store.dispatch("notification", this.locales.NOT_ALLOWED);
                return
            }
            if (this.selectedEmployee && this.selectedEmployee.identifier == data.identifier) {
                this.selectedEmployee = false
                return
            }

            this.selectedEmployee = data

        },
        eventHandler(event) {
            switch (event.data.action) {
                case "mechanicCategoryResult":
                    // this.mechanicCategoryItemName = this.mechanicCategoryData[event.data.payload.modId];
                    // this.mechanicCategoryItemName.count = event.data.payload.count;


                    break;
                case "SET_MY_RANK":
                    this.myRank = event.data.payload
                    break
                default:
                    break;
            }
        },
        SecondsToDate(seconds, includeHours) {
            const date = new Date(null);
            date.setSeconds(seconds); // specify value for SECONDS here
            let day = date.getDate()
            let month = date.getMonth() + 1
            let hours = date.getHours()
            let minutes = date.getMinutes()
            if (minutes < 10) {
                minutes = '0' + minutes
            }
            if (hours < 10) {
                hours = '0' + hours
            }
            if (day < 10) {
                day = '0' + day
            }
            if (month < 10) {
                month = '0' + month
            }

            let formattedClock = `${hours}:${minutes}`

            return `${day}.${month}.${date.getFullYear()} ${includeHours ? formattedClock : ''}`
        },
        ItemImage(item) {
            return `${this.itemImagesFolder}${item.image}`
        },
        GetAccessText(permissions, isBoss){
            let hasAllAccess = true
            if(!isBoss){
                if(Object.keys(permissions).length < 7){
                    hasAllAccess = false
                }
                for(let key in permissions){
                    
                    let permission = permissions[key]
                    if(!permission){
                        hasAllAccess = false

                    }
    
                }
              

            }
            return hasAllAccess ? this.locales.ALL_ACCESS : this.locales.PARTIAL_ACCESS 
        },
        setCurrentBossPage(payload) {
            if (payload == 'ranks') {
                if (!this.CheckPermission('accessRanks')) {
                    this.$store.dispatch("notification", this.locales.NOT_ALLOWED);

                    return
                }
            }
            if (payload == 'employees') {

                if (!this.CheckPermission('accessEmployees')) {
                    this.$store.dispatch("notification", this.locales.NOT_ALLOWED);

                    return
                }
            }
            if (payload == 'logs') {
                if (!this.CheckPermission('accessLogs')) {
                    this.$store.dispatch("notification", this.locales.NOT_ALLOWED);

                    return
                }
            }
            this.currentBossPage = payload
            if (payload == 'inventory') {
                this.RefreshDragDrop()
            }
        },
        HireNewPlayer() {
            postNUI("HireNewPlayer", {
                id: this.hirePlayerId
            })
        },
        TogglePermission(checked, permissionName) {
            postNUI("ChangePermission", {
                allow: checked,
                permissionName,
                rankLevel: this.selectedRank.grade,

            })
        },
        SelectRank(rank) {
            this.selectedEmployee = false
            this.editPermissions = false
            if (this.selectedRank && this.selectedRank.grade == rank.grade) {
                this.selectedRank = false
                return
            }

            this.selectedRank = rank
        },
        ToggleEditPermissions(val) {
            if (this.CheckPermission() == false) {
                this.$store.dispatch("notification", this.locales.NOT_ALLOWED);
                return
            }
            if (this.selectedRank.isBoss) {
                this.$store.dispatch("notification", this.locales.CANT_EDIT_PERMISSON);
                return
            }
            this.editPermissions = val
        },
        RefreshDragDrop() {
            Vue.nextTick(() => {

                $('.player-item').draggable({
                    helper: "clone",
                    appendTo: "body",
                    scroll: false,
                    start: (event, ui) => {
                        $(ui.helper).css('width', `${$(event.target).width()}px`);

                    },
                    drag: function (event, ui) {

                    },
                    stop: (event, ui) => {

                    }
                });
                $('.boss-item').draggable({
                    helper: "clone",
                    appendTo: "body",
                    scroll: false,
                    start: (event, ui) => {
                        $(ui.helper).css('width', `${$(event.target).width()}px`);

                    },
                    drag: function (event, ui) {

                    },
                    stop: (event, ui) => {

                    }
                });
                $(".boss-slots").droppable({
                    accept: ".player-item",
                    drop: (event, ui) => {
                        if ($(ui.helper).attr('item-data') && this.inventoryInputAmount >= 0 && parseInt(this.inventoryInputAmount)) {

                            const item = JSON.parse($(ui.helper).attr('item-data'))
                            postNUI("DragItem", {
                                fromInv: 'player',
                                amount: this.inventoryInputAmount || item.amount,
                                name: item.name,
                                metadata: item.metadata,
                                slot: item.slot,
                                label: item.label,
                                image: item.image,

                            });
                        }else {
                            this.$store.dispatch("notification", this.locales.NOT_ALLOWED);
                        }

                    }
                })
                $(".player-slots").droppable({
                    accept: ".boss-item",
                    drop: (event, ui) => {
                        if ($(ui.helper).attr('item-data') && this.inventoryInputAmount >= 0 && parseInt(this.inventoryInputAmount)) {
                            const item = JSON.parse($(ui.helper).attr('item-data'))

                            postNUI("DragItem", {
                                fromInv: 'boss',
                                amount: this.inventoryInputAmount || item.amount,
                                name: item.name,
                                metadata: item.metadata,
                                label: item.label,
                                image: item.image,

                            });
                        }else {
                            this.$store.dispatch("notification", this.locales.NOT_ALLOWED);
                        }
                    }
                })
            })
        },
        FormatMoney(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        },
    },

    computed: {
        ...Vuex.mapState({
            playerInventory: state => state.bossmenuPage.playerInventory,
            bossInventory: state => state.bossmenuPage.bossInventory,
            itemImagesFolder: state => state.bossmenuPage.itemImagesFolder,
            employees: state => state.bossmenuPage.employees,
            ranks: state => state.bossmenuPage.ranks,
            money: state => state.bossmenuPage.money,
            logs : state => state.bossmenuPage.logs,
            locales : state => state.locales,

        }),
        getFilteredLogs(){
            if(this.filterLog.length > 0){
                return this.logs.filter((log) => log.message.toLowerCase().includes(this.filterLog.toLowerCase()))

            }
            return this.logs
        },
    },

    mounted() {
        window.addEventListener("message", this.eventHandler);
    },
    beforeDestroy() {
        window.removeEventListener("message", this.eventHandler);
    }
};
