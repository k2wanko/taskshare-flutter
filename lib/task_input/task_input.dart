import 'package:flutter/material.dart';
import 'package:taskshare/l10n/l10n.dart';
import 'package:taskshare/task_input/task_addition_bloc.dart';
import 'package:taskshare/task_input/task_addtion_bloc_provider.dart';
import 'package:taskshare/util/app_logger.dart';

class TaskInput extends StatefulWidget {
  final TextEditingController textController;

  const TaskInput({
    Key key,
    @required this.textController,
  }) : super(key: key);

  @override
  TaskInputState createState() => TaskInputState();
}

class TaskInputState extends State<TaskInput> {
  final _focusNode = FocusNode();
  @override
  void initState() {
    final bloc = TaskAdditionBlocProvider.of(context);
    super.initState();
    _focusNode.addListener(() {
      log.info(_focusNode);
      if (!_focusNode.hasFocus) {
        bloc.updateScreenMode.add(TaskScreenMode.list);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = TaskAdditionBlocProvider.of(context);
    final l10n = L10N.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 20.0,
        bottom: 8.0,
      ),
      child: Column(
        children: <Widget>[
          StreamBuilder<String>(
            initialData: bloc.failed.value,
            stream: bloc.failed,
            builder: (context, snap) {
              // TODO: expand touch area
              return TextField(
                controller: widget.textController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'New Task',
                  errorText: snap.data,
                ),
                onSubmitted: log.info,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.all(0.0),
                icon: Icon(
                  Icons.open_in_new,
                ),
                onPressed: () {
                  bloc.demandFullscreen.add(null);
                },
                color: Theme.of(context).accentColor,
              ),
              FlatButton(
                onPressed: () async {
                  bloc.save.add(widget.textController.text);
                },
                child: Text(
                  l10n.buttonSave,
                ),
                textTheme: ButtonTextTheme.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
