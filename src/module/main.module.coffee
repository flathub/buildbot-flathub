# Register new module
class App extends App
    constructor: ->
        return [
            'ui.router'
            'ui.bootstrap'
            'ngAnimate'
            'guanlecoja.ui'
            'bbData'
        ]


class State extends Config
    constructor: ($stateProvider, glMenuServiceProvider, bbSettingsServiceProvider) ->

        # Name of the state
        name = 'flathub'

        # Menu configuration
        glMenuServiceProvider.addGroup
            name: name
            caption: 'Flathub'
            icon: 'cubes'
            order: 0

        # Configuration
        cfg =
            group: name
            caption: 'Flathub'
            builderid: 2

        $stateProvider.state
            controller: "#{name}Controller"
            controllerAs: "c"
            templateUrl: "flathub_view/views/#{name}.html"
            name: name
            url: "/?numbuilds"
            data: cfg

        bbSettingsServiceProvider.addSettingsGroup
            name: 'Flathub'
            caption: 'Flathub related settings'
            items: [
                type: 'integer'
                name: 'testSetting'
                caption: 'A test setting'
                default_value: 200
            ]

class Flathub extends Controller
    constructor: ($scope, $q, @$window, dataService, bbSettingsService, resultsService,
        @$uibModal, @$timeout, $state, $stateParams) ->
        angular.extend this, resultsService
        settings = bbSettingsService.getSettingsGroup('Flathub')
        @testSetting = settings.testSetting.value

        builderid=$state.current.data.builderid

        data = dataService.open().closeOnDestroy($scope)

        data.getBuilders(builderid).onNew = (builder) ->
            $scope.numbuilds = 200
            if $stateParams.numbuilds?
                $scope.numbuilds = +$stateParams.numbuilds
            $scope.builds = builder.getBuilds
                property: ["owners", "workername", "flathub-arches", "flathub-build-id", "flathub-official-build", "repository"]
                limit: $scope.numbuilds
                order: '-number'
            $scope.buildrequests = builder.getBuildrequests(claimed:false)
            # $scope.builds.onChange=refreshContextMenu
            # $scope.buildrequests.onChange=refreshContextMenu
