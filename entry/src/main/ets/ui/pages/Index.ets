import { SingleWaterItem } from '../widgets/SingleWaterItem'
import { IndexViewModel } from '../viewmodels/IndexViewModel';
import { SettingsPageBuilder } from './SettingsPage';
import { LogWaterPageBuilder } from './LogWaterPage';
import { HistoryPageBuilder } from './HistoryPage';
import { SetTargetPageBuilder } from './SetTargetPage';
import { ProgressHeader } from '../widgets/ProgressHeader';
import { ActionButton } from '../widgets/ActionButton';

const SETTINGS_PAGE_ROUTE: string = 'settings';
const LOG_WATER_PAGE_ROUTE: string = 'log-water';
const HISTORY_PAGE_ROUTE: string = 'HydrationHistoryPage';
const SET_TARGET_PAGE_ROUTE: string = 'set-target';

@Entry
@Component
struct Index {
  indexVm: IndexViewModel = new IndexViewModel()
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()

  @Builder
  PagesMap(name: string) {
    if (name === SETTINGS_PAGE_ROUTE) {
      SettingsPageBuilder()
    } else if (name === LOG_WATER_PAGE_ROUTE) {
      LogWaterPageBuilder()
    } else if (name === HISTORY_PAGE_ROUTE) {
      HistoryPageBuilder()
    } else if (name === SET_TARGET_PAGE_ROUTE) {
      SetTargetPageBuilder()
    }
  }

  aboutToAppear(): void {
    this.indexVm.aboutToAppear();
  }

  onPageShow(): void {
    this.indexVm.aboutToAppear();
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        Gauge({ value: this.indexVm.currentWater, min: 0, max: this.indexVm.waterTarget }) {
          List({ space: 0 }) {
            ListItem() {
              this.buildHeader();
            }
            .width('95%')
            .margin({ bottom: 6 })

            if (this.indexVm.isLoading) {
              ListItem() {
                Text('Loading hydration dashboard...')
                  .fontSize(11)
                  .fontColor(0xCCFFFFFF)
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }
              .width('95%')
              .margin({ bottom: 8 })
            }

            if (this.indexVm.hasLoadError) {
              ListItem() {
                Column({ space: 8 }) {
                  Text(this.indexVm.loadErrorText)
                    .fontSize(11)
                    .fontColor(0xFFFFC58A)
                    .textAlign(TextAlign.Center)
                  ActionButton('Retry', () => {
                    this.indexVm.aboutToAppear();
                  }, '62%')
                }
                .width('100%')
              }
              .width('95%')
              .margin({ bottom: 8 })
            }

            ListItem() {
              Row() {
                SingleWaterItem(this.indexVm.quickPresets[0], $r('app.color.gradient_green'), 'app.media.bottle_250', 15,
                  (value: number) => this.indexVm.addWater(value), true);
                SingleWaterItem(this.indexVm.quickPresets[1], $r('app.color.gradient_orange'), 'app.media.bottle_300', 20,
                  (value: number) => this.indexVm.addWater(value));
              }
            }
            .width('95%')
            .margin({ bottom: 8 });

            ListItem() {
              Row() {
                SingleWaterItem(this.indexVm.quickPresets[2], $r('app.color.gradient_brown'), 'app.media.bottle_500', 20,
                  (value: number) => this.indexVm.addWater(value), true);
                SingleWaterItem(this.indexVm.quickPresets[3], $r('app.color.gradient_blue'), 'app.media.bottle_1L', 20,
                  (value: number) => this.indexVm.addWater(value));
              };
            }
            .width('95%')
            .margin({ bottom: 8 });

            ListItem() {
              Column({ space: 8 }) {
                Text(this.indexVm.actionStateText)
                  .fontSize(10)
                  .fontColor(this.indexVm.currentWater >= this.indexVm.waterTarget && this.indexVm.waterTarget > 0 ? 0xFF9FF0B0 : 0xCCFFFFFF)
                  .textAlign(TextAlign.Center)
                  .width('100%')

                Row({ space: 8 }) {
                  ActionButton('Custom Log', () => {
                    this.pageStack.pushPath({ name: LOG_WATER_PAGE_ROUTE, param: null });
                  })
                  ActionButton('Undo Last', () => {
                    this.indexVm.undoLastEntry();
                  })
                }
                .justifyContent(FlexAlign.Center)

                Row({ space: 8 }) {
                  ActionButton('History', () => {
                    this.pageStack.pushPath({ name: HISTORY_PAGE_ROUTE, param: null });
                  })
                  ActionButton('Settings', () => {
                    this.pageStack.pushPath({ name: SETTINGS_PAGE_ROUTE, param: null });
                  })
                }
                .justifyContent(FlexAlign.Center)
              }
            }
            .width('95%')
            .margin({ bottom: 18 })
          }
          .width('100%')
          .height('100%')
          .listDirection(Axis.Vertical)
          .edgeEffect(EdgeEffect.None)
          .scrollBar(BarState.Off)
          .focusable(true)
          .focusOnTouch(true)
          .defaultFocus(true)
        }
        .colors($r('app.color.gauge'))
        .width('100%')
        .height('100%')
        .indicator(null)
        .strokeWidth(18)
        .trackShadow({ radius: 3, offsetX: 3, offsetY: 3 })
        .value(this.indexVm.currentWater)
        .align(Alignment.Center)
      }
      .width('100%')
      .height('100%')
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [[$r('app.color.base_background_gradient_start'), 0.0],
          [$r('app.color.base_background_gradient_end'), 1]]
      })
    }
    .hideTitleBar(true)
    .navDestination(this.PagesMap)
    .hideBackButton(true)
  }

  @Builder
  buildHeader() {
    ProgressHeader(this.indexVm.headerText, this.indexVm.remainingText, this.indexVm.statusText,
      this.indexVm.completionText, this.indexVm.lastActionText, this.indexVm.reminderText, this.indexVm.showReminderChip,
      this.indexVm.currentWater >= this.indexVm.waterTarget && this.indexVm.waterTarget > 0 ? 0xFF9FF0B0 : 0xFFFFD780)
  }
}
