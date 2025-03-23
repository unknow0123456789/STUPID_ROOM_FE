import 'package:fe/Base/ChosenTextStyle.dart';
import 'package:fe/Base/CustomChecker.dart';
import 'package:fe/Base/CustomTabController.dart';
import 'package:fe/Base/FormatedTextField.dart';
import 'package:fe/Base/ImageButton.dart';
import 'package:fe/Base/WrappedText.dart';
import 'package:fe/Models/CustomCheckerItem.dart';
import 'package:fe/Models/Stupid_Client.dart';
import 'package:fe/Models/Stupid_Device.dart';
import 'package:fe/Providers/customChecker_ChangeNotifier.dart';
import 'package:fe/Providers/dataOptions_changeNotifier.dart';
import 'package:fe/Providers/device_changeNotifier.dart';
import 'package:fe/Providers/registerProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientDetailMobileView extends ConsumerWidget
{

  Stupid_Client client;
  final ChangeNotifierProvider<DeviceChangeNotifier> deviceController;
  final ChangeNotifierProvider<DataOptions_ChangeNotifier> dataOptionController;

  List<Widget> dataTabs=[
    Container(
      color: Colors.purpleAccent,
    ),
    Container(
      color: Colors.yellowAccent,
    )
  ];


  ClientDetailMobileView(this.client,this.deviceController,this.dataOptionController);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context,constraints)
      {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            children: [
              Expanded(
                  flex:5,
                  child: CustomTabController(dataTabs)
              ),
              Expanded(
                  flex: 4,
                  child: CustomTabController(
                      [
                        _devicesInfoPartialTab(deviceController),
                        _dataPickerPartialTab(deviceController,dataOptionController)
                      ]
                  )
              )
            ],
          ),
        );
      },
    );
  }

}

class _dataPickerPartialTab extends ConsumerWidget {

  final ChangeNotifierProvider<DeviceChangeNotifier> deviceController;
  final ChangeNotifierProvider<DataOptions_ChangeNotifier> dataOptionController;
  final ChangeNotifierProvider<CustomCheckerChangeNotifier> deviceFieldsCheckerController=ChangeNotifierProvider((ref) => CustomCheckerChangeNotifier());

  bool firstLoad=true;
  _dataPickerPartialTab(this.deviceController,this.dataOptionController);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (firstLoad) {
      firstLoad = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        try
        {
          ref.read(deviceFieldsCheckerController).items= (ref.read(deviceController).focusedDevice!=null)?
          List.generate(
              ref.read(deviceController).focusedDevice!.fields.length, (index) =>
              CustomCheckerItem(ref.read(deviceController).focusedDevice!.fields[index],true)
          )
              :
          [];
        }
        catch (e)
        {
          print(e);
        }
      });
    }
    return LayoutBuilder(
      builder: (context,constraints)=>
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: constraints.maxHeight,
              color: Colors.blueGrey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                          "Data Picker",
                          style: bottomPartialTabClientDetailTextStyle
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex:1,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          "Devices List",
                                          style: deviceListTitleTextStyle,
                                        ),
                                      )
                                    ]
                                        +
                                        List.generate(ref.watch(deviceController).devicesList.length, (index)=>
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                              child: CustomButton(
                                                borderRadius: BorderRadius.circular(10),
                                                onTap: ()
                                                {
                                                  ref.read(deviceController).focusedDevice=ref.watch(deviceController).devicesList[index];
                                                },

                                                child: _deviceCard(
                                                  device: ref.watch(deviceController).devicesList[index],
                                                  isSelected:
                                                  (
                                                      ref.watch(deviceController).focusedDevice!=null
                                                          &&
                                                          ref.watch(deviceController).devicesList[index].id==ref.watch(deviceController).focusedDevice!.id
                                                  ),
                                                  selectedBackgroundColor: Colors.black87,
                                                ),
                                              ),
                                            )
                                        )
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: LayoutBuilder(
                                  builder: (context,constraints)=>
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Data Options",
                                                style: deviceDetailTitleTextStyle,
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  child: _dataOptions(
                                                          (int timeRange,String timeUnitLetter,List<String>fields) async {
                                                            if (ref.watch(deviceController).focusedDevice!=null && ref.watch(deviceController).focusedDevice!.id!=null) {
                                                              await ref.read(deviceController).getDeviceData(
                                                                      ref.watch(loginController).userToken!,
                                                                      ref.watch(deviceController).focusedDevice!.id!,
                                                                      timeRange,
                                                                      timeUnitLetter,
                                                                      fields
                                                              );
                                                            }
                                                          },
                                                      dataOptionController,
                                                      deviceController,
                                                      deviceFieldsCheckerController
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

class _dataOptions extends ConsumerWidget
{

  final void Function(int range, String timeUnitLetter, List<String> fields) submit;
  final ChangeNotifierProvider<DataOptions_ChangeNotifier> dataOptionController;
  final ChangeNotifierProvider<DeviceChangeNotifier> deviceController;
  final ChangeNotifierProvider<CustomCheckerChangeNotifier> deviceFieldsCheckerController;
  final TextEditingController rangeController=TextEditingController();

  _dataOptions(this.submit,this.dataOptionController,this.deviceController,this.deviceFieldsCheckerController);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FormatedTextField(
          controller: rangeController,
          label: "Time Range",
          fillColor: Colors.black87,
          labelColor: Colors.blue,
        ),
        LayoutBuilder(
          builder:(context, constraints)=>
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  width: constraints.maxWidth,
                  child: DropdownButton(
                      dropdownColor: Colors.black54,
                      value: ref.watch(dataOptionController).timeUnitList[ref.watch(dataOptionController).selectedTimeUnitIndex].value,
                      borderRadius: BorderRadius.circular(15),
                      items: ref.read(dataOptionController).timeUnitList.map((e) =>
                          DropdownMenuItem(
                            value: e.value,
                            child: SizedBox(
                              height: 50,
                              width: constraints.maxWidth-30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        child: Text(
                                            e.value.toUpperCase(),
                                            style: timeUnitDropDownListLetterTextStyle
                                        )
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                            e.name,
                                            style: timeUnitDropDownListTextStyle
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: ()
                            {
                              ref.read(dataOptionController).selectedTimeUnitIndex=ref.read(dataOptionController).timeUnitList.indexOf(e);
                            },
                          )
                      ).toList(),
                      onChanged: (e){

                      }
                  ),
                ),
              ),
        ),

        CustomChecker(
          itemController: deviceFieldsCheckerController,
          title: "Fields",
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CustomButton(
              onTap: ()
              {
                // print("Range Value: ${rangeController.text}");
                // print("Fields Value: ${List.generate(ref.watch(deviceFieldsCheckerController).items.length, (index) => "Value: ${ref.watch(deviceFieldsCheckerController).items[index].value}, isCheck: ${ref.watch(deviceFieldsCheckerController).items[index].isCheck}")}");
                submit(
                  int.parse(rangeController.text),
                  ref.watch(dataOptionController).timeUnitList[ref.watch(dataOptionController).selectedTimeUnitIndex].value,
                  (ref.watch(deviceFieldsCheckerController).getChecked()).map((e) => (e as CustomCheckerItem).value).toList()
                );
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                // width: 100,
                height: 50,
                color: Colors.blueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        "Submit",
                        style: dataOptionMobileTextStyle,
                      ),
                    ),
                    Icon(
                        Icons.search,
                      size: 30,
                      color: Colors.white,
                    )
                  ],
                ),
              )
          ),
        )
      ],
    );
  }

}



class _devicesInfoPartialTab extends ConsumerWidget
{

  final ChangeNotifierProvider<DeviceChangeNotifier> deviceController;


  _devicesInfoPartialTab(this.deviceController);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context,constraints)=>
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: constraints.maxHeight,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                            "Devices Information",
                            style: bottomPartialTabClientDetailTextStyle
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex:1,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: double.infinity,
                                          child: Text(
                                            "Devices List",
                                            style: deviceListTitleTextStyle,
                                          ),
                                        )
                                      ]
                                          +
                                          List.generate(ref.watch(deviceController).devicesList.length, (index)=>
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                child: CustomButton(
                                                  borderRadius: BorderRadius.circular(10),
                                                  onTap: ()
                                                  {
                                                    ref.read(deviceController).focusedDevice=ref.watch(deviceController).devicesList[index];
                                                  },

                                                  child: _deviceCard(
                                                    // device: Stupid_Device(id:111111111,name: "hehhhhhhhhhhhhhhhhhhhhhhhhhhhhheeeeeee", measurementName: "nope",fields: [],clientId: -1),
                                                    device: ref.watch(deviceController).devicesList[index],
                                                    isSelected:
                                                    (
                                                        ref.watch(deviceController).focusedDevice!=null
                                                            &&
                                                            ref.watch(deviceController).devicesList[index].id==ref.watch(deviceController).focusedDevice!.id
                                                    ),
                                                  ),
                                                ),
                                              )
                                          )
                                          +
                                          <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                              child: CustomButton(
                                                borderRadius: BorderRadius.circular(10),
                                                onTap: ()
                                                {

                                                },

                                                child: _deviceCard(
                                                  isAdditional: true,
                                                ),
                                              ),
                                            )
                                          ]
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Device Details",
                                            style: deviceDetailTitleTextStyle,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: ((){
                                              final device=ref.watch(deviceController).focusedDevice;
                                              return (device!=null)?_deviceDetail(device):Container();
                                            })(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ]
                ),
              ),
            ),
          ),
    );
  }

}

class _deviceDetail extends ConsumerWidget
{
  final Stupid_Device device;


  _deviceDetail(this.device);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context,constraints)=>
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _device_atrribute_box("Device ID", device.id),
                  _device_atrribute_box("Device Name",device.name),
                  _device_atrribute_box("Measurement Name",device.measurementName),
                  _device_atrribute_box("Fields", device.fields)
                ],
              ),
            ),
          ),
    );
  }

}

class _device_atrribute_box extends ConsumerWidget
{
  final String attrName;
  final dynamic value;

  _device_atrribute_box(this.attrName, this.value);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _device_attr_title(attrName),
            ]
                +
                ((value is List)
                    ? List<Widget>.generate((value as List).length, (index) =>
                    Text(
                        (value as List)[index].toString(),
                        style: deviceValueDeviceDetailTextStyle
                    )
                )
                    :[
                  Text(
                      value.toString(),
                      style: deviceValueDeviceDetailTextStyle
                  ),])
        ),
      ),
    );
  }

}

class _device_attr_title extends Text
{
  _device_attr_title(String data):
        super(
          data,
          style: GoogleFonts.righteous(
              textStyle:TextStyle(
                  color: Colors.amber,
                  // fontWeight: FontWeight.bold,
                  fontSize: 15
              )
          )
      );
}

class _deviceCard extends ConsumerWidget
{

  final Stupid_Device device;
  final bool isSelected;
  final bool isAdditional;
  final Color backgroundColor;
  final Color selectedBackgroundColor;
  final Color selectedStrokeColor;
  final Color strokeColor;



  _deviceCard._internal({
    required this.device,
    required this.isSelected,
    this.isAdditional=false,
    this.backgroundColor=Colors.black54,
    this.selectedBackgroundColor=Colors.blueGrey,
    this.strokeColor=Colors.transparent,
    this.selectedStrokeColor=Colors.white
  });

  factory _deviceCard({
    Stupid_Device? device,
    bool isSelected=false,
    bool isAdditional=false,
    backgroundColor=Colors.black54,
    selectedBackgroundColor=Colors.blueGrey,
    strokeColor=Colors.transparent,
    selectedStrokeColor=Colors.white
  })
  {
    if (!isAdditional && device==null)
      throw Exception("Stupid_Device Object is expected if not Additional card!");
    return _deviceCard._internal(
      device: (device!=null)?device:Stupid_Device.dump(),
      isSelected: isSelected,
      isAdditional: isAdditional,
      backgroundColor: backgroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      strokeColor: strokeColor,
      selectedStrokeColor: selectedStrokeColor,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                    color: (isAdditional)?Colors.lightBlueAccent.withOpacity(0.5):((isSelected)?selectedBackgroundColor:backgroundColor),
                    border: Border.all(
                        color: (isSelected)?selectedStrokeColor:strokeColor,
                        width: (isSelected)?3:0
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                height: 50,
                width: constraints.maxWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: Center(
                              child: (isAdditional)?
                              Icon(
                                CupertinoIcons.add,
                                color: Colors.white,
                                size: 30,
                              )
                                  :
                              WrappedTextAutoScroll(
                                  device.id.toString(),
                                  style: deviceCardIdTextStyle
                              )
                          ),
                        )
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Center(
                            child: (isAdditional)?
                            WrappedTextAutoScroll(
                              "Add device",
                              style: deviceCardNameTextStyle,
                            )
                                :
                            WrappedTextAutoScroll(
                              device.name.toString(),
                              style: deviceCardNameTextStyle,
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
    );
  }

}