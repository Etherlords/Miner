/**
 * Created with IntelliJ IDEA.
 * User: WORKSATION
 * Date: 4/19/13
 * Time: 10:20 PM
 * To change this template use File | Settings | File Templates.
 */
package scene {
import core.scene.AbstractSceneController;

public interface ISceneControllerFactory {
    function newController(id:String):AbstractSceneController;
}
}
