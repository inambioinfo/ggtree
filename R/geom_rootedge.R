##' display root edge
##'
##'
##' @title geom_rootedge
##' @param rootedge length of rootedge; use phylo$root.edge if rootedge = NULL (by default).
##' @param ... additional parameters
##' @return ggplot layer
##' @export
##' @author Guangchuang Yu
geom_rootedge <- function(rootedge = NULL, ...) {
    mapping <- aes_(x = ~x, y = ~y, xend = ~x, yend = ~y,
                    branch.length = ~branch.length,
                    node = ~node, parent = ~parent)
    layer(
        stat = StatRootEdge,
        data  = NULL,
        mapping = mapping,
        geom = "segment",
        position = "identity",
        show.legend = NA,
        params = list(rootedge = rootedge, ...),
        check.aes = FALSE,
        inherit.aes = FALSE
    )

}



StatRootEdge <- ggproto("StatRootEdge", Stat,
                        compute_group = function(self, data, scales, params, rootedge) {
                            d <- data[data$parent == data$node,]
                            if (is.null(rootedge)) {
                                rootedge <- d$branch.length
                            }
                            if (is.null(rootedge)) {
                                xend <- d$x
                            } else if (is.na(rootedge)) {
                                xend <- d$x
                            } else {
                                xend <- d$x - rootedge
                            }

                            data.frame(x = d$x, y = d$y,
                                       xend = xend, yend = d$y)
                        },
                        required_aes = c("x", "y", "xend", "yend")
                        )
