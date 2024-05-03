import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/layout/app_cubit/cubit.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../layout/app_cubit/cubit.dart';
import '../styles/icon_broken.dart';


Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  @required Function function,
  @required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );


Widget defaultButtonWithIcon({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  @required Function function,
  @required String text,
  IconData icon
}) =>
    Container(
      width: width,
      height: 40.0,
      child: MaterialButton(
        onPressed: function,
        child: Row(
          children: [
            Icon(icon,size: 20,color: Colors.white,),
            SizedBox(width: 5,),
            Text(
              isUpperCase ? text.toUpperCase() : text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );


Widget defaultTextButton({
  @required Function function,
  @required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
      ),
    );

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTap,
  bool isPassword = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
  bool isClickable = true,
  BuildContext context,
  @required bool isDark,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color:Colors.grey[400]),
        prefixIcon: Icon(
          prefix,
          color:isDark? Colors.white:Colors.black,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
            color:isDark? Colors.white:Colors.black,
          ),
        )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget myDivider({double heightPadding =15,}) =>Padding(
  padding:  EdgeInsets.symmetric(
    vertical:heightPadding,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

Widget divider() =>Padding(
  padding: const EdgeInsets.symmetric(
    horizontal:20,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(
    context,
    widget,
    ) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (route) {
        return false;
      },
    );

void showToast({
  @required String text,
  @required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );
// enum
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

showErrorSnackBar(BuildContext context,String error) => showTopSnackBar(
  context,
    CustomSnackBar.error(
    message:  error,
  ),
);

showSuccessSnackBar(BuildContext context,String success) => showTopSnackBar(
  context,
  CustomSnackBar.success(
    message:  success,
    textStyle: const TextStyle(
      color: Colors.black
    ),
  ),
);

Widget buildLoading() {
  return Center(
    child: SizedBox(
      width: 150,
      height: 150,
      child: Lottie.asset(
        'assets/a.json',
      ),
    ),
  );
}

Widget defaultAppBar({
  @required BuildContext context,
  String title,
  List<Widget> actions,
})=>AppBar(
  title:  Text(
    title,
  ),
  actions: actions,
  titleSpacing: 5.0,
  leading: IconButton(
    onPressed: (){
      Navigator.pop(context);
    },
    icon: const Icon(
      IconBroken.Arrow___Left_2,
    ),
  ),
);





class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final bool isChat;
  final BuildContext context;
  const ExpandableTextWidget({Key key,  this.text,this.context,this.isChat}) : super(key: key);

  @override
  _ExpandableTextWidgetState createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  String firstHalf;
  String secondHalf;
  BuildContext context;
  bool hiddenText=true;

  double textHeight =627/5.63;
  @override
  void initState(){
    super.initState();
    if(widget.text.length>textHeight){
      firstHalf =widget.text.substring(0,textHeight.toInt());
      secondHalf =widget.text.substring(textHeight.toInt()+1,widget.text.length);
    }else{
      firstHalf=widget.text;
      secondHalf="";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty?SmallText(
        height: 1.5,
        color:AppCubit.get(context).isDark?  Colors.white: Colors.black,size: 16,text: firstHalf,):Column(
        children:
        [
          SmallText(height: 1.5,color:AppCubit.get(context).isDark? Colors.white: Colors.black,size: 16,text:hiddenText?(firstHalf+'  ....'):(firstHalf+secondHalf)),
          InkWell(
            onTap: (){
              setState(() {
                hiddenText=!hiddenText;
              });
            },
            child: Row(
              children:
              [
                SmallText(text:'Read more',color:defaultColor,),
                Icon(hiddenText?Icons.arrow_drop_down:Icons.arrow_drop_up,color:defaultColor,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SmallText extends StatelessWidget {
  final Color color;
  final String text;
  double size;
  double height;
  final bool isOverFlow;
  SmallText({
    Key key,
    this.color =const Color(0xFFccc7c5),
    this.size=12,
    this.height=1.2,
    this.isOverFlow =false,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        text,
        // maxLines: 2,
        style: TextStyle(
          //overflow:isOverFlow ?TextOverflow.ellipsis,
            height: height,
            color: color,
            fontSize: size==0?12 :size,
            fontFamily: 'Roboto'
        )
    );
  }
}

class ExpandableTextChatWidget extends StatefulWidget {
  final String text;
  final bool isChat;
  final BuildContext context;
  const ExpandableTextChatWidget({Key key,  this.text,this.context,this.isChat}) : super(key: key);

  @override
  _ExpandableTextChatWidgetState createState() => _ExpandableTextChatWidgetState();
}

class _ExpandableTextChatWidgetState extends State<ExpandableTextChatWidget> {
  String firstHalf;
  String secondHalf;
  BuildContext context;
  bool hiddenText=true;

  double textHeight =627/5.63;
  @override
  void initState(){
    super.initState();
    if(widget.text.length>textHeight){
      firstHalf =widget.text.substring(0,textHeight.toInt());
      secondHalf =widget.text.substring(textHeight.toInt()+1,widget.text.length);
    }else{
      firstHalf=widget.text;
      secondHalf="";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty?SmallText(
        height: 1.5,
        color: Colors.black ,size: 16,text: firstHalf,):Column(
        children:
        [
          SmallText(height: 1.5,color:Colors. black,size: 16,text:hiddenText?(firstHalf+'  ....'):(firstHalf+secondHalf)),
          InkWell(
            onTap: (){
              setState(() {
                hiddenText=!hiddenText;
              });
            },
            child: Row(
              children:
              [
                SmallText(text:'Read more',color:defaultColor,),
                Icon(hiddenText?Icons.arrow_drop_down:Icons.arrow_drop_up,color:defaultColor,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
