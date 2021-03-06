import 'package:flutter/material.dart';

class ChartTile extends StatelessWidget {
  const ChartTile({
    Key key,
    this.dismissibleId,
    this.onDismissed,
    this.onEndIcon,
    this.endIcon,
    @required this.child,
    this.icon,
    @required this.label,
    this.width,
    this.svg,
    this.press,
  }) : super(key: key);

  final Function(DismissDirection) onDismissed;

  final String dismissibleId, label, svg;
  final Widget child;
  final IconData icon, endIcon;
  final VoidCallback press, onEndIcon;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (dismissibleId == null)
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: press,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            color: const Color(0xFFF5F6F9),
            child: Row(
              children: [
                if (icon != null)
                  SizedBox(
                      width: 30,
                      child: Icon(
                        icon,
                        color: Theme.of(context).accentColor,
                      )),
                const SizedBox(width: 20),
                Expanded(
                  child: child,
                ),
                InkWell(
                  onTap: onEndIcon,
                  child: Icon(
                    endIcon,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    else
      return Dismissible(
        key: ValueKey(dismissibleId),
        background: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          color: Colors.transparent,
          child: Row(
            children: [
              const Spacer(),
              Text(
                'DELETAR',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: onEndIcon,
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Tem certeza?'),
              content: const Text('Os ingredientes ser??o perdidos!'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text('N??o'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text('Sim'),
                ),
              ],
            ),
          );
        },
        onDismissed: onDismissed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: press,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              color: const Color(0xFFF5F6F9),
              child: Row(
                children: [
                  if (icon != null) //|| svg != null)
                    SizedBox(
                        width: 30,
                        child: Icon(
                          icon,
                          color: Theme.of(context).accentColor,
                        )),
                  const SizedBox(width: 20),
                  Expanded(
                    child: child,
                  ),
                  InkWell(
                    onTap: onEndIcon,
                    child: Icon(
                      endIcon,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
